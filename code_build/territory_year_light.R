### arrange environment ###

# remove all objects
rm(list = ls())

# install pacman package if not installed
if (!require("pacman")) install.packages("pacman")

# load packages
pacman::p_load(tidyverse)
pacman::p_load(readxl)
pacman::p_load(data.table)
pacman::p_load(purrr)

### create panel data for light ###

# import light data
files <- list.files(path = "b_temp/", pattern = glob2rx("*territory*xls*")) # https://stackoverflow.com/questions/18028225/r-list-files-with-multiple-conditions
fullpaths <- str_c("b_temp/", files)
data <- map(fullpaths, read_excel)
names(data) <- gsub("b_temp/territory_light_|[_GEO/_NKR/_TRA]|\\.xls", "", fullpaths)
fulldata <- do.call(rbind, data)
fulldata2 <- fulldata %>% 
  mutate(
    satellite_year = rownames(fulldata),
    satellite = str_sub(satellite_year, 1, 3),
    year = str_sub(satellite_year, 4, 7)
  )

# append light data
light <- fulldata2 %>% 
  select(territory, MEAN, year) %>% 
  group_by(territory, year) %>%
  summarise(light = mean(MEAN))

# change <chr> into <num>
light$year <- as.numeric(as.character(light$year))
  
### merge income data with light data ###

# import income data
income <- read_csv("b_temp/country_year_rgdpe.csv") %>% 
  setnames(old = c("rgdpe", "countrycode"), new = c("income", "territory"))
  
# merge income with light
income_light <- light %>% 
  left_join(income) %>% 
  select(territory, year, light, income)

# export csv
write_csv(income_light, "b_output/territory_year_light.csv")

