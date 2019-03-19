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

# extract year_fe
yfe <- input2 %>% 
  separate(name, into = c("drop", "year"), sep = -4) %>% 
  select(-fe_error, -drop) %>% 
  setnames(old = c("fe_estimate"), new = c("year_fe")) %>% 
  add_row(year = 1992, year_fe = 0, .before = 1) # add row for year 1992 with 0 value

# change <chr> to <num>
yfe$year <- as.numeric(as.character(yfe$year))

# Take one-year lag of year_fe
yfe_lag <- yfe %>% 
  mutate(year_lag = year + 1) %>% 
  select(-year) %>% 
  setnames(old = c("year_lag", "year_fe"), new = c("year", "year_fe_lag"))

# Take one-year lag of light and GDP
input1_lag <- input1 %>%
  mutate(year_lag = year + 1) %>% 
  select(-year) %>% 
  setnames(old = c("year_lag", "light", "income"), new = c("year", "light_lag", "income_lag"))

# Merge them all
final_data <- input1 %>%
  inner_join(input1_lag) %>% 
  inner_join(yfe) %>% 
  inner_join(yfe_lag) %>% 
  mutate(
    # Predict GDP growth in percentage (equation 2 in the paper)
    growth_hat = 100*(input3$coeff_light[1] * (log(light) - log(light_lag)) + (year_fe - year_fe_lag)), 
    # Actual GDP growth for parent states
    growth = 100*(log(income) - log(income_lag))
  )

# export csv
write_csv(final_data, "a_output/territory_year_growth_hat.csv")

