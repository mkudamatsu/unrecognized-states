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
pacman::p_load(broom)

### predict cfe for unrecognized states ###

# import data
estim <- read_csv("a_temp/regress_country_fe_on_mean_light_coeff.csv")
panel <- read_csv("b_output/territory_year_light.csv")

# obtain mean light and predict cfe
territory_fe <- panel %>% 
  group_by(territory) %>%
  summarise(mean_light = mean(light)) %>% 
  mutate(ln_mean_light = log(mean_light),
         country_fe = estim$const[1] + estim$ln_mean_light_coeff[1] * ln_mean_light 
         ) %>% 
  select(territory, country_fe)

# export csv
write_csv(territory_fe, "a_temp/territory_country_fe.csv")
