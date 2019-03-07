### arrange environment ###

# remove all objects
rm(list = ls())

# install pacman package if not installed
if (!require("pacman")) install.packages("pacman")

# load packages
pacman::p_load(tidyverse)
pacman::p_load(data.table)
pacman::p_load(ggplot2)
pacman::p_load(forcat)


### visualize GDP growth for unrecognized states and parent countries ###

## prepare data ##
recognized <- read_csv("a_output/territory_year_growth_hat.csv") %>% 
  subset(growth != "NA") %>% 
  mutate(actual = str_c(territory, " (actual)"),
         predicted = str_c(territory, " (predicted)")) %>% 
  select(year, territory, actual, predicted, growth_hat, growth)

unrecognized <- read_csv("a_output/territory_year_growth_hat.csv") %>% 
  select(year, territory, growth_hat) %>% 
  anti_join(recognized) %>% 
  setnames(old = c("growth_hat"), new = c("growth"))

actual_gdp <- recognized %>%
  select(year, actual, growth) %>% 
  setnames(old = c("actual"), new = c("territory"))

fulldata <- recognized %>% 
  select(year, predicted, growth_hat) %>% 
  setnames(old = c("predicted", "growth_hat"), new = c("territory" ,"growth")) %>% 
  full_join(actual_gdp) %>% 
  full_join(unrecognized)

## plot actual and real GDP growth ##

# plot GEO
geo <- fulldata %>% 
  subset(territory == "GEO (predicted)" | territory == "GEO (actual)")

geo$year <- as.factor(geo$year)

geo$territory <- factor(geo$territory, levels = c("GEO (predicted)", "GEO (actual)"))

geo %>% 
  ggplot(aes(x = year, y = growth, fill = territory)) +
  geom_bar(stat = "identity", position = position_dodge(), width = 0.75) +
  ylim(-60, 60) +
  labs(x = "Year", y = "Annual growth (%)") +
  scale_fill_manual(labels = c("Georgia (predicted)", "Georgia (actual)"),
                    values = c("#1F78B4", "#A6CEE3")) +
  theme(axis.text.x = element_text(angle = 70, size = 10, vjust = 0.5),
        axis.title.x = element_text(vjust = -0.35),
        axis.title.y = element_text(vjust = 0.35),
        legend.text = element_text(size = 10),
        legend.position = "top",
        legend.title=element_blank(),
        legend.spacing.x = unit(0.2, "cm"),
        panel.grid.major = element_line(size = 0))

ggsave("a_output/plot_growth_hat_bar_GEO_actual.png")

# plot MDA
mda <- fulldata %>% 
  subset(territory == "MDA (predicted)" | territory == "MDA (actual)")

mda$year <- as.factor(mda$year)

mda$territory <- factor(mda$territory, levels = c("MDA (predicted)", "MDA (actual)"))

mda %>% 
  ggplot(aes(x = year, y = growth, fill = territory)) +
  geom_bar(stat = "identity", position = position_dodge(), width = 0.75) +
  ylim(-60, 60) +
  labs(x = "Year", y = "Annual growth (%)") +
  scale_fill_manual(labels = c("Moldova (predicted)", "Moldova (actual)"),
                    values = c("#1F78B4", "#A6CEE3")) +
  theme(axis.text.x = element_text(angle = 70, size = 10, vjust = 0.5),
        axis.title.x = element_text(vjust = -0.35),
        axis.title.y = element_text(vjust = 0.35),
        legend.text = element_text(size = 10),
        legend.position = "top",
        legend.title=element_blank(),
        legend.spacing.x = unit(0.2, "cm"),
        panel.grid.major = element_line(size = 0))

ggsave("a_output/plot_growth_hat_bar_MDA_actual.png")

# plot AZE
aze <- fulldata %>% 
  subset(territory == "AZE (predicted)" | territory == "AZE (actual)")

aze$year <- as.factor(aze$year)

aze$territory <- factor(aze$territory, levels = c("AZE (predicted)", "AZE (actual)"))

aze %>% 
  ggplot(aes(x = year, y = growth, fill = territory)) +
  geom_bar(stat = "identity", position = position_dodge(), width = 0.75) +
  ylim(-60, 60) +
  labs(x = "Year", y = "Annual growth (%)") +
  scale_fill_manual(labels = c("Azerbaijan (predicted)", "Azerbaijan (actual)"),
                    values = c("#1F78B4", "#A6CEE3")) +
  theme(axis.text.x = element_text(angle = 70, size = 10, vjust = 0.5),
        axis.title.x = element_text(vjust = -0.35),
        axis.title.y = element_text(vjust = 0.35),
        legend.text = element_text(size = 10),
        legend.position = "top",
        legend.title=element_blank(),
        legend.spacing.x = unit(0.2, "cm"),
        panel.grid.major = element_line(size = 0))

ggsave("a_output/plot_growth_hat_bar_AZE_actual.png")

## plot growth for unrecognized states and parent countries ##

# plot GEO_ABK
geo_abk <- fulldata %>% 
  subset(territory == "GEO (actual)" | territory == "ABK")

geo_abk$year <- as.factor(geo_abk$year)

geo_abk %>% 
  ggplot(aes(x = year, y = growth, fill = territory)) +
  geom_bar(stat = "identity", position = position_dodge(), width = 0.75) +
  ylim(-60, 60) +
  labs(x = "Year", y = "Annual growth (%)") +
  scale_fill_manual(labels = c("Abkhazia", "Georgia (actual)"),
    values = c("#fc9272", "#A6CEE3")) +
  theme(axis.text.x = element_text(angle = 70, size = 10, vjust = 0.5),
        axis.title.x = element_text(vjust = -0.35),
        axis.title.y = element_text(vjust = 0.35),
        legend.text = element_text(size = 10),
        legend.position = "top",
        legend.title=element_blank(),
        legend.spacing.x = unit(0.2, "cm"),
        panel.grid.major = element_line(size = 0))

ggsave("a_output/plot_growth_hat_bar_GEO_ABK_actual.png")

# plot GEO_SOS
geo_sos <- fulldata %>% 
  subset(territory == "GEO (actual)" | territory == "SOS")

geo_sos$year <- as.factor(geo_sos$year)

geo_sos$territory <- factor(geo_sos$territory, levels = c("SOS", "GEO (actual)"))

geo_sos %>% 
  ggplot(aes(x = year, y = growth, fill = territory)) +
  geom_bar(stat = "identity", position = position_dodge(), width = 0.75) +
  ylim(-60, 60) +
  labs(x = "Year", y = "Annual growth (%)") +
  scale_fill_manual(labels = c("South Ossetia", "Georgia (actual)"),
                    values = c("#fc9272", "#A6CEE3")) +
  theme(axis.text.x = element_text(angle = 70, size = 10, vjust = 0.5),
        axis.title.x = element_text(vjust = -0.35),
        axis.title.y = element_text(vjust = 0.35),
        legend.text = element_text(size = 10),
        legend.position = "top",
        legend.title=element_blank(),
        legend.spacing.x = unit(0.2, "cm"),
        panel.grid.major = element_line(size = 0))

ggsave("a_output/plot_growth_hat_bar_GEO_SOS_actual.png")

# plot MDA_TRA
mda_tra <- fulldata %>% 
  subset(territory == "MDA (actual)" | territory == "TRA")

mda_tra$year <- as.factor(mda_tra$year)

mda_tra$territory <- factor(mda_tra$territory, levels = c("TRA", "MDA (actual)"))

mda_tra %>% 
  ggplot(aes(x = year, y = growth, fill = territory)) +
  geom_bar(stat = "identity", position = position_dodge(), width = 0.75) +
  ylim(-60, 60) +
  labs(x = "Year", y = "Annual growth (%)") +
  scale_fill_manual(labels = c("Transnistria", "Moldova (actual)"),
                    values = c("#fc9272", "#A6CEE3")) +
  theme(axis.text.x = element_text(angle = 70, size = 10, vjust = 0.5),
        axis.title.x = element_text(vjust = -0.35),
        axis.title.y = element_text(vjust = 0.35),
        legend.text = element_text(size = 10),
        legend.position = "top",
        legend.title=element_blank(),
        legend.spacing.x = unit(0.2, "cm"),
        panel.grid.major = element_line(size = 0))

ggsave("a_output/plot_growth_hat_bar_MDA_TRA_actual.png")

# plot AZE_NKR
aze_nkr <- fulldata %>% 
  subset(territory == "AZE (actual)" | territory == "NKR")

aze_nkr$year <- as.factor(aze_nkr$year)

aze_nkr$territory <- factor(aze_nkr$territory, levels = c("NKR", "AZE (actual)"))

aze_nkr %>% 
  ggplot(aes(x = year, y = growth, fill = territory)) +
  geom_bar(stat = "identity", position = position_dodge(), width = 0.75) +
  ylim(-60, 60) +
  labs(x = "Year", y = "Annual growth (%)") +
  scale_fill_manual(labels = c("Nagorno-Karabakh", "Azerbaijan (actual)"),
                    values = c("#fc9272", "#A6CEE3")) +
  theme(axis.text.x = element_text(angle = 70, size = 10, vjust = 0.5),
        axis.title.x = element_text(vjust = -0.35),
        axis.title.y = element_text(vjust = 0.35),
        legend.text = element_text(size = 10),
        legend.position = "top",
        legend.title=element_blank(),
        legend.spacing.x = unit(0.2, "cm"),
        panel.grid.major = element_line(size = 0))

ggsave("a_output/plot_growth_hat_bar_AZE_NKR_actual.png")
