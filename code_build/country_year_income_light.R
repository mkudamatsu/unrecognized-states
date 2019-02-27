### arrange environment ###

# remove all objects
rm(list = ls())

# install pacman package if not installed
if (!require("pacman")) install.packages("pacman")

# load packages
pacman::p_load(tidyverse)
pacman::p_load(readxl)
pacman::p_load(data.table) # http://rprogramming.net/rename-columns-in-r/


### create panel data for light ###

# import light data
l_10.92 <- read_excel("b_temp/country_light_F101992.xls", sheet = 1)
l_10.93 <- read_excel("b_temp/country_light_F101993.xls", sheet = 1)
l_10.94 <- read_excel("b_temp/country_light_F101994.xls", sheet = 1)
l_12.94 <- read_excel("b_temp/country_light_F121994.xls", sheet = 1)
l_12.95 <- read_excel("b_temp/country_light_F121995.xls", sheet = 1)
l_12.96 <- read_excel("b_temp/country_light_F121996.xls", sheet = 1)
l_12.97 <- read_excel("b_temp/country_light_F121997.xls", sheet = 1)
l_12.98 <- read_excel("b_temp/country_light_F121998.xls", sheet = 1)
l_12.99 <- read_excel("b_temp/country_light_F121998.xls", sheet = 1)
l_14.97 <- read_excel("b_temp/country_light_F141997.xls", sheet = 1)
l_14.98 <- read_excel("b_temp/country_light_F141998.xls", sheet = 1)
l_14.99 <- read_excel("b_temp/country_light_F141999.xls", sheet = 1)
l_14.00 <- read_excel("b_temp/country_light_F142000.xls", sheet = 1)
l_14.01 <- read_excel("b_temp/country_light_F142001.xls", sheet = 1)
l_14.02 <- read_excel("b_temp/country_light_F142002.xls", sheet = 1)
l_14.03 <- read_excel("b_temp/country_light_F142003.xls", sheet = 1)
l_15.00 <- read_excel("b_temp/country_light_F152000.xls", sheet = 1)
l_15.01 <- read_excel("b_temp/country_light_F152001.xls", sheet = 1)
l_15.02 <- read_excel("b_temp/country_light_F152002.xls", sheet = 1)
l_15.03 <- read_excel("b_temp/country_light_F152003.xls", sheet = 1)
l_15.04 <- read_excel("b_temp/country_light_F152004.xls", sheet = 1)
l_15.05 <- read_excel("b_temp/country_light_F152005.xls", sheet = 1)
l_15.06 <- read_excel("b_temp/country_light_F152006.xls", sheet = 1)
l_15.07 <- read_excel("b_temp/country_light_F152007.xls", sheet = 1)
l_16.04 <- read_excel("b_temp/country_light_F162004.xls", sheet = 1)
l_16.05 <- read_excel("b_temp/country_light_F162005.xls", sheet = 1)
l_16.06 <- read_excel("b_temp/country_light_F162006.xls", sheet = 1)
l_16.07 <- read_excel("b_temp/country_light_F162007.xls", sheet = 1)
l_16.08 <- read_excel("b_temp/country_light_F162008.xls", sheet = 1)
l_16.09 <- read_excel("b_temp/country_light_F162009.xls", sheet = 1)
l_18.10 <- read_excel("b_temp/country_light_F182010.xls", sheet = 1)
l_18.11 <- read_excel("b_temp/country_light_F182011.xls", sheet = 1)
l_18.12 <- read_excel("b_temp/country_light_F182012.xls", sheet = 1)
l_18.13 <- read_excel("b_temp/country_light_F182013.xls", sheet = 1)

# create new column
l_10.92$satellite_year <- c("F10_1992")
l_10.93$satellite_year <- c("F10_1993")
l_10.94$satellite_year <- c("F10_1994")
l_12.94$satellite_year <- c("F12_1994")
l_12.95$satellite_year <- c("F12_1995")
l_12.96$satellite_year <- c("F12_1996")
l_12.97$satellite_year <- c("F12_1997")
l_12.98$satellite_year <- c("F12_1998")
l_12.99$satellite_year <- c("F12_1999")
l_14.97$satellite_year <- c("F14_1997")
l_14.98$satellite_year <- c("F14_1998")
l_14.99$satellite_year <- c("F14_1999")
l_14.00$satellite_year <- c("F14_2000")
l_14.01$satellite_year <- c("F14_2001")
l_14.02$satellite_year <- c("F14_2002")
l_14.03$satellite_year <- c("F14_2003")
l_15.00$satellite_year <- c("F15_2000")
l_15.01$satellite_year <- c("F15_2001")
l_15.02$satellite_year <- c("F15_2002")
l_15.03$satellite_year <- c("F15_2003")
l_15.04$satellite_year <- c("F15_2004")
l_15.05$satellite_year <- c("F15_2005")
l_15.06$satellite_year <- c("F15_2006")
l_15.07$satellite_year <- c("F15_2007")
l_16.04$satellite_year <- c("F16_2004")
l_16.05$satellite_year <- c("F16_2005")
l_16.06$satellite_year <- c("F16_2006")
l_16.07$satellite_year <- c("F16_2007")
l_16.08$satellite_year <- c("F16_2008")
l_16.09$satellite_year <- c("F16_2009")
l_18.10$satellite_year <- c("F18_2010")
l_18.11$satellite_year <- c("F18_2011")
l_18.12$satellite_year <- c("F18_2012")
l_18.13$satellite_year <- c("F18_2013")

# append light data
all_light <- rbind(l_10.92, l_10.93, l_10.94, l_12.94, l_12.95, l_12.96, l_12.97, l_12.98, l_12.99, l_14.97, l_14.98, l_14.99, l_14.00, l_14.01,l_14.02, l_14.03, l_15.00, l_15.01, l_15.02, l_15.03, l_15.04, l_15.05, l_15.06, l_15.07, l_16.04, l_16.05, l_16.06, l_16.07, l_16.08, l_16.09, l_18.10, l_18.11, l_18.12, l_18.13) %>% 
  select(GID_0, MEAN, satellite_year) %>% 
  separate(satellite_year, into = c("satellite", "year"), sep = "_", convert = TRUE) %>% 
  group_by(GID_0, year) %>%
  summarise(light = mean(MEAN))

# match country name with ID
light <- read_excel("b_temp/countryname_light.xls") %>% 
  right_join(all_light) %>% # need to get rid of Vatican City (VAT) observation
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
View(unmatched_light_code)
View(unmatched_income_code)

# delete name column from income data
income_new <- select(income, -country)

# merge income with light
income_light <- light %>% 
  full_join(income_new) %>% 
  select(countrycode, country, year, income, light)

# export csv
write_csv(income_light, "b_output/country_year_income_light.csv")
