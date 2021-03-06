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

# create tex file of regression results
stargazer(
  reg,
  out = "a_output/income_light_cfe_yfe_result.tex", 
  float=FALSE,   # removes the \begin{table} and \end{table}
  dep.var.labels = c("Dependent Variable: log real GDP"),
  keep = c("light", "year"),
  covariate.labels = c(
    "log mean light", 
    "Year 1993", "Year 1994", "Year 1995", "Year 1996", "Year 1997", "Year 1998", "Year 1999", "Year 2000", "Year 2001","Year 2002", 
    "Year 2003", "Year 2004", "Year 2005", "Year 2006", "Year 2007", "Year 2008", "Year 2009", "Year 2010", "Year 2011", "Year 2012", 
    "Year 2013"
    ),
  add.lines = list(
    c("Country fixed effects", "Yes"),
    c("Number of countries", "177")
    ),
  keep.stat = c("adj.rsq", "n"),
  table.layout = "-d-t-as="
  )

# estimate multiway-clustered SE


### export point estimates and SE ###

# create table of point estimates and SE for ydum
year_fe <- tidy(reg) %>% 
  select(term, estimate, std.error) %>% 
  filter(substr(term, 1, 12) == "factor(year)") %>% 
  mutate(
    year = str_sub(term, -4, -1),
    name = str_c("year_fe", year)
  ) %>%   
  select(-term, -year) %>% 
  setnames(old = c("estimate", "std.error"), new = c("fe_estimate", "fe_error")) %>% 
  select(name, everything())

write_csv(year_fe, "a_temp/income_light_cfe_yfe_year_fe.csv") 

# create table of point estimates and SE for coeff on light
light_coeff_transposed <- tidy(reg) %>% 
  select(term, estimate, std.error) %>% 
  filter(term == "ln_light") %>%  
  mutate(
    light = str_sub(term, 4, 8),
    name = str_c("coeff_", light)
  ) %>%   
  select(-term, -light) %>% 
  select(name, everything())

light_coeff <- transpose(light_coeff_transposed) %>% 
  as_tibble

rownames(light_coeff) <- colnames(light_coeff_transposed)
colnames(light_coeff) <- light_coeff[1, ] # first row becomes header
light_coeff <- light_coeff[-1, ] # remove first row

write_csv(light_coeff, "a_temp/income_light_cfe_yfe_light_coeff.csv") 

# create cross-country data with point estimates and SE for coeff on cdum
country_coeff <- tidy(reg) %>% 
  select(term, estimate, std.error) %>% 
  filter(substr(term, 1, 19) == "factor(countrycode)") %>%  
  setnames(old = c("estimate", "std.error"), new = c("fe_estimate", "fe_error")) %>% 
  mutate(countrycode = str_sub(term, -3, -1)) %>% 
  select(-term) %>% 
  select(countrycode, everything())

write_csv(country_coeff, "a_temp/income_light_cfe_yfe_country_coeff.csv") 

