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

# import and append light data
files <- list.files(path = "b_temp/", pattern = glob2rx("*country_*xls*")) # https://stackoverflow.com/questions/18028225/r-list-files-with-multiple-conditions
fullpaths <- str_c("b_temp/", files)
data <- map(fullpaths, read_excel)
names(data) <- gsub("b_temp/country_light_|\\.xls", "", fullpaths)
fulldata <- do.call(rbind, data)
fulldata2 <- fulldata %>% 
  mutate(
    satellite_year = rownames(fulldata),
    satellite = str_sub(satellite_year, 1, 3),
    year = str_sub(satellite_year, 4, 7)
  )

# amend light data
all_light <- fulldata2 %>% 
  select(GID_0, MEAN, year) %>% 
  group_by(GID_0, year) %>%
  summarise(light = mean(MEAN))

# change <chr> into <num>
all_light$year <- as.numeric(as.character(all_light$year))

# match country name with ID
light <- read_excel("b_temp/countryname_light.xls") %>% 
  right_join(all_light) %>%
  select(-FID) %>% 
  setnames(old = c("GID_0", "NAME_0"), new = c("countrycode", "country"))

### merge income data with light data ###

# import and subset income data
income <- read_csv("b_temp/country_year_rgdpe.csv") %>% 
  setnames(old = c("rgdpe"), new = c("income")) %>% 
  subset(year >= 1992 & year <= 2013)

# check unmatched variables by code
unmatched_light_code <- anti_join(light, income, by = "countrycode")
unmatched_income_code <- anti_join(income, light, by = "countrycode") # no unmatched countrycodes for income
#View(unmatched_light_code)
#View(unmatched_income_code)

# delete name column from income data
income_new <- select(income, -country)

# merge income with light
income_light <- light %>% 
  full_join(income_new) %>% 
  select(countrycode, country, year, income, light)

# export csv
write_csv(income_light, "b_output/country_year_income_light.csv")
