### arrange environment ###

# remove all objects
rm(list = ls())

# install pacman package if not installed
if (!require("pacman")) install.packages("pacman")

# load packages
pacman::p_load(tidyverse)
pacman::p_load(stargazer)
pacman::p_load(data.table)
pacman::p_load(broom)
pacman::p_load(modelr)
pacman::p_load(ggplot2)

### regress country fixed effects on mean light ###

# create cross-section data 
cfe <- read_csv("a_temp/income_light_cfe_yfe_country_coeff.csv")
data <- read_csv("b_output/country_year_income_light.csv") %>% 
  group_by(countrycode, country) %>%
  summarise(mean_light = mean(light)) %>%
  inner_join(cfe) %>% 
  mutate(ln_mean_light = log(mean_light)) %>% 
  select(countrycode, country, mean_light, ln_mean_light, everything())

# run OLS regression of cfe on mean_light
reg <- lm(fe_estimate ~ ln_mean_light, data)
#stargazer(reg, type = "text")

# save results in latex format
stargazer(
  reg,
  type = "latex",
  keep.stat = c("n", "rsq"),
  table.layout = "-ldc-t-s=",
  out = "a_output/regress_country_fe_on_mean_light_result.tex"
)

## plot fe_estimate (y) against ln_mean_light (x) ##

# generate grid of values
grid_values <- data %>% 
  data_grid(ln_mean_light)

# add predictions
fullgrid <- grid_values %>% 
  add_predictions(reg)

# plot predictions
ggplot(data, aes(ln_mean_light)) +
  geom_point(aes(y = fe_estimate)) +
  geom_line(aes(y = pred), data = fullgrid, color = "red", size = 1)

# save plot
ggsave("a_output/regress_country_fe_on_mean_light_plot.png")

## create csv of estimates and SE for constant and coeff on mean_light ##

# extract estimates and SE
output3_transposed <- tidy(reg) %>% 
  select(term, estimate, std.error)

# rename rows
output3_transposed[1, 1] <- "const"
output3_transposed[2, 1] <- "ln_mean_light_coeff"

# transpose table
output3 <- transpose(output3_transposed)
rownames(output3) <- colnames(output3_transposed)
colnames(output3) <- output3[1, ] # first row becomes header
output3 <- output3[-1, ]

# export csv
write_csv(output3, "a_temp/regress_country_fe_on_mean_light_coeff.csv") 

