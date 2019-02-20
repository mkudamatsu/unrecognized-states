# remove all the objects in the memory
rm(list = ls())

## load tidyverse
pacman::p_load(tidyverse)

## import data
pacman::p_load(readxl) # see http://www.sthda.com/english/wiki/reading-data-from-excel-files-xls-xlsx-into-r
pwt <- read_excel("input/pwt90.xlsx", sheet = 3)

## transform data
tidy_pwt <- pwt %>% 
  select(1,2,4,5) # see https://www.datanovia.com/en/lessons/select-data-frame-columns-in-r/
tidy_pwt

## create csv
write_csv(tidy_pwt, "b_temp/country_year_rgdpe.csv")
# see https://www.rdocumentation.org/packages/readr/versions/0.1.1/topics/write_csv

