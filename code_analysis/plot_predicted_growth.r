### arrange environment ###

# remove all objects
rm(list = ls())

# install pacman package if not installed
if (!require("pacman")) install.packages("pacman")

# load packages
pacman::p_load(tidyverse)
pacman::p_load(ggplot2)

### visualize predited real GDP for unrecognixed states and their parent countries ###

# import data
data <- read_csv("a_output/territory_year_growth_hat.csv")

# plot Transnistria and Moldova
mda_tra <- data %>% 
  subset(territory == "MDA" | territory == "TRA")

mda_tra %>% 
  ggplot(aes(year, color = factor(territory))) + 
  geom_line(aes(y = growth_hat)) +
  geom_line(aes(y = growth), linetype = "dashed") +
  labs(x = "Year", y = "Annual growth (%)") +
  theme(axis.text.x = element_text(angle = 50, size = 10, vjust = 0.5),
        axis.title.x = element_text(color = "#006d2c", vjust = -0.35),
        axis.title.y = element_text(color = "#006d2c", vjust = 0.7),
        legend.title = element_text(color = "#006d2c", size = 10),
        legend.position = "top") +
  scale_color_manual(name = "country", values=c("#8c6bb1", "#7bccc4"),
                     labels = c("Moldova", "Transnistria")) +
  annotate("text", x = 2011, y = 20, label = "actual GDP growth", size = 3)

ggsave("a_output/plot_growth_hat_TRA.png")

# plot Nagorno-Karabakh and Azerbaijan
aze_nkr <- data %>% 
  subset(territory == "AZE" | territory == "NKR")

aze_nkr %>% 
  ggplot(aes(year, color = factor(territory))) + 
  geom_line(aes(y = growth_hat)) +
  geom_line(aes(y = growth), linetype = "dashed") +
  labs(x = "Year", y = "Annual growth (%)") +
  theme(axis.text.x = element_text(angle = 50, size = 10, vjust = 0.5),
        axis.title.x = element_text(color = "#006d2c", vjust = -0.35),
        axis.title.y = element_text(color = "#006d2c", vjust = 0.7),
        legend.title = element_text(color = "#006d2c", size = 10),
        legend.position = "top") +
  scale_color_manual(name = "country", values = c("#8c6bb1", "#7bccc4"),
                     labels = c("Azerbaijan", "Nagorno-Karabakh")) +
  annotate("text", x = 2008, y = 20, label = "actual GDP", size = 3)

ggsave("a_output/plot_growth_hat_NKR.png")

# plot Abkhazia, South Ossetia, and Georgia proper
geo_abk_sos <- data %>% 
  subset(territory == "GEO" | territory == "ABK" | territory == "SOS")

geo_abk_sos %>% 
  ggplot(aes(year, color = factor(territory))) + 
  geom_line(aes(y = growth_hat)) +
  geom_line(aes(y = growth), linetype = "dashed") +
  labs(x = "Year", y = "Annual growth (%)") +
  theme(axis.text.x = element_text(angle = 50, size = 10, vjust = 0.5),
        axis.title.x = element_text(color = "#006d2c", vjust = -0.35),
        axis.title.y = element_text(color = "#006d2c", vjust = 0.7),
        legend.title = element_text(color = "#006d2c", size = 10),
        legend.position = "top") +
  scale_color_manual(name = "country", values = c("#7bccc4", "#8c6bb1", "#0868ac"), 
                     labels = c("Abkhasia", "Georgia", "South Ossetia")) +
  annotate("text", x = 2011, y = 20, label = "actual GDP", size = 3)

ggsave("a_output/plot_growth_hat_GEO.png")
