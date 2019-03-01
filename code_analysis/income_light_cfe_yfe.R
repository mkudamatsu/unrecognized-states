### arrange environment ###

# remove all objects
rm(list = ls())

# install pacman package if not installed
if (!require("pacman")) install.packages("pacman")

# load packages
pacman::p_load(tidyverse)
pacman::p_load(stargazer)
pacman::p_load(data.table)
pacman::p_load(lfe) 
pacman::p_load(broom) # https://stackoverflow.com/questions/26866839/how-to-export-coefficients-of-the-regression-analysis-from-rstudio-to-a-spreadsh


### regress income on light with cfe and yfe ###

# import data and drop Georgia, Azerbaijan, and Moldova
data <- read_csv("b_output/country_year_income_light.csv") %>% 
  subset(countrycode != "GEO" & countrycode != "AZE" & countrycode != "MDA")

# drop observations with missing income data
balanced_panel <- data %>% 
  filter(!is.na(income))

# obtain the number of observations per country
nobs_per_country <- balanced_panel %>% 
  count(countrycode)

# show countries with fewer than 22 observations
nobs_per_country %>% 
  filter(n < 22)

# drop countries with missing income data
final_panel <- balanced_panel %>% 
  full_join(nobs_per_country) %>% 
  subset(n >= 22)

# create new variables
data4analysis <- mutate(final_panel,
                        ln_income = log(income),
                        ln_light = log(light)
)

# run OLS of ln_income on ln_light, cdum, ydum
reg <- felm(ln_income ~ ln_light + factor(countrycode) + factor(year) -1 | 0 | 0 | countrycode + year, data4analysis)

# show results
#stargazer(
          #reg[c("ln_light", "factor(year)1993", "factor(year)1994", "factor(year)1995", "factor(year)1996", "factor(year)1997", "factor(year)1998", "factor(year)1999", 
          #"factor(year)2000", "factor(year)2001", "factor(year)2002", "factor(year)2003", "factor(year)2004", "factor(year)2005", "factor(year)2006", "factor(year)2007", "factor(year)2008", "factor(year)2009", 
          #"factor(year)2010", "factor(year)2011", "factor(year)2012", "factor(year)2013")],
          #type = "text",
          #dep.var.labels = c("Dependent Variable: ln(GDP)"),
          #covariate.labels = c("ln(light)", "Year 1993", "Year 1994", "Year 1995", "Year 1996", "Year 1997", "Year 1998", "Year 1999", 
                               #"Year 2000", "Year 2001","Year 2002", "Year 2003", "Year 2004", "Year 2005", "Year 2006", "Year 2007", "Year 2008", "Year 2009", 
                               #"Year 2010", "Year 2011", "Year 2012", "Year 2013"),
          #add.lines = list(c("Country fixed effexts", "Yes"),
                           #c("Number of countries", "177"),
                           #c("Number of observations", "3894")),
          #keep.stat = c("adj.rsq"),
          #table.layout = "-dc-ts-a="
#)

# create tex file of regression results
#stargazer(reg, out = "a_output/income_light_cfe_yfe_result.tex")

# estimate multiway-clustered SE


### export point estimates and SE ###

# create table of point estimates and SE for coeff on light and ydum
output1 <- tidy(reg) %>% 
  select(term, estimate, std.error) %>% 
  slice(179:201) %>%  # maybe not the best option to do it by row number
  mutate(
    year = str_sub(term, -4, -1),
    name = str_c("year_fe", year)
  ) %>%   
  select(-term, -year)

outputlight <- tidy(reg) %>% 
  select(term, estimate, std.error) %>% 
  slice(1) %>%  # maybe not the best option to do it by row number
  mutate(
    light = str_sub(term, 4, 8),
    name = str_c("coeff_", light)
  ) %>%   
  select(-term, -light)

new <- full_join(outputlight, output1) %>% 
  setnames(old = c("estimate", "std.error"), new = c("fe_estimate", "fe_error")) %>% 
  select(name, everything())

# transpose table
transposed <- transpose(new)
rownames(transposed) <- colnames(new)
colnames(transposed) <- transposed[1, ] # first row becomes header
transposed <- transposed[-1, ] # remove first row

write_csv(transposed, "a_temp/income_light_cfe_yfe_light_coeff.csv") 

# create cross-country data with point estimates and SE for coeff on cdum
output2 <- tidy(reg) %>% 
  select(term, estimate, std.error) %>% 
  slice(2:178) %>%  # maybe not the best option to do it by row number
  setnames(old = c("estimate", "std.error"), new = c("fe_estimate", "fe_error")) %>% 
  mutate(countrycode = str_sub(term, -3, -1)) %>% 
  select(-term) %>% 
  select(countrycode, everything())

write_csv(output2, "a_temp/income_light_cfe_yfe_country_coeff.csv") 

