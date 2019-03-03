### arrange environment ###

# remove all objects
rm(list = ls())

# install pacman package if not installed
if (!require("pacman")) install.packages("pacman")

# load packages
pacman::p_load(tidyverse)
pacman::p_load(data.table)

### predict real GDP for unrecognized states and their parent countries ###

# import data
input1 <- read_csv("b_output/territory_year_light.csv") # light panel for unrecognized territories and their parent countries
input2 <- read_csv("a_temp/income_light_cfe_yfe_year_fe.csv") # year_fe
input3 <- read_csv("a_temp/income_light_cfe_yfe_light_coeff.csv") # light_coeff
input4 <- read_csv("a_temp/territory_country_fe.csv") # country_fe

# extract year_fe
yfe <- input2 %>% 
  separate(name, into = c("drop", "year"), sep = -4) %>% 
  select(-fe_error, -drop) %>% 
  setnames(old = c("fe_estimate"), new = c("year_fe")) %>% 
  add_row(year = 1992, year_fe = 0, .before = 1) # add row for year 1992 with 0 value

# change <chr> to <num>
yfe$year <- as.numeric(as.character(yfe$year))

# predict GDP
gdp_pred <- input1 %>% 
  full_join(input4) %>% 
  full_join(yfe) %>%
  mutate(ln_gdp_hat = input3$coeff_light[1] * log(light) + country_fe + year_fe,
         gdp_hat = exp(ln_gdp_hat)) %>%
  select(-ln_gdp_hat)%>% 
  select(territory, year, gdp_hat, income)

# export csv
write_csv(gdp_pred, "a_output/territory_year_gdp_hat.csv")

