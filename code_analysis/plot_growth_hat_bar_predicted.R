### arrange environment ###

# remove all objects
rm(list = ls())

# install pacman package if not installed
if (!require("pacman")) install.packages("pacman")

# load packages
pacman::p_load(tidyverse)
pacman::p_load(data.table)
pacman::p_load(ggplot2)


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

geo %>% 
  ggplot(aes(x = year, y = growth, fill = territory)) +
  geom_bar(stat = "identity", position = position_dodge(), width = 0.75) +
  scale_x_discrete(name = "Year") +
  scale_y_continuous(name = "Annual growth (%)", limits = c(-60,60), 
                     expand = c(0,0), breaks = seq(-50,50, by = 10)) +
  scale_fill_manual(labels = c("Georgia (actual)", "Georgia (predicted)"),
                    values = c("#1F78B4", "#A6CEE3")) +
  theme(legend.title = element_blank(),
        legend.text = element_text(size = 10),
        legend.position = "top",
        legend.spacing.x = unit(0.2, "cm"),
        legend.margin = margin(b = -0.15, unit = "cm"),
        axis.title.x = element_text(size = 10, vjust = -0.5),
        axis.title.y = element_text(size = 10, vjust = 1),
        axis.text.x = element_text(angle = 70, vjust = 0.5),
        panel.grid.major.x = element_blank(),
        panel.grid.minor = element_blank())

ggsave("a_output/plot_growth_hat_GEO.png")

# plot MDA
mda <- fulldata %>% 
  subset(territory == "MDA (predicted)" | territory == "MDA (actual)")

mda$year <- as.factor(mda$year)

mda %>% 
  ggplot(aes(x = year, y = growth, fill = territory)) +
  geom_bar(stat = "identity", position = position_dodge(), width = 0.75) +
  scale_x_discrete(name = "Year") +
  scale_y_continuous(name = "Annual growth (%)", limits = c(-60,60), 
                     expand = c(0,0), breaks = seq(-50,50, by = 10)) +
  scale_fill_manual(labels = c("Moldova (actual)", "Moldova (predicted)"),
                    values = c("#1F78B4", "#A6CEE3")) +
  theme(legend.title = element_blank(),
        legend.text = element_text(size = 10),
        legend.position = "top",
        legend.spacing.x = unit(0.2, "cm"),
        legend.margin = margin(b = -0.15, unit = "cm"),
        axis.title.x = element_text(size = 10, vjust = -0.5),
        axis.title.y = element_text(size = 10, vjust = 1),
        axis.text.x = element_text(angle = 70, vjust = 0.5),
        panel.grid.major.x = element_blank(),
        panel.grid.minor = element_blank())

ggsave("a_output/plot_growth_hat_MDA.png")

# plot AZE
aze <- fulldata %>% 
  subset(territory == "AZE (predicted)" | territory == "AZE (actual)")

aze$year <- as.factor(aze$year)

aze %>% 
  ggplot(aes(x = year, y = growth, fill = territory)) +
  geom_bar(stat = "identity", position = position_dodge(), width = 0.75) +
  scale_x_discrete(name = "Year") +
  scale_y_continuous(name = "Annual growth (%)", limits = c(-60,60), 
                     expand = c(0,0), breaks = seq(-50,50, by = 10)) +
  scale_fill_manual(labels = c("Azerbaijan (actual)", "Azerbaijan (predicted)"),
                    values = c("#1F78B4", "#A6CEE3")) +
  theme(legend.title = element_blank(),
        legend.text = element_text(size = 10),
        legend.position = "top",
        legend.spacing.x = unit(0.2, "cm"),
        legend.margin = margin(b = -0.15, unit = "cm"),
        axis.title.x = element_text(size = 10, vjust = -0.5),
        axis.title.y = element_text(size = 10, vjust = 1),
        axis.text.x = element_text(angle = 70, vjust = 0.5),
        panel.grid.major.x = element_blank(),
        panel.grid.minor = element_blank())

ggsave("a_output/plot_growth_hat_AZE.png")

## plot growth for unrecognized states and parent countries ##

# plot GEO_ABK
geo_abk <- fulldata %>% 
  subset(territory == "GEO (predicted)" | territory == "ABK")

geo_abk$year <- as.factor(geo_abk$year)

geo_abk %>% 
  ggplot(aes(x = year, y = growth, fill = territory)) +
  geom_bar(stat = "identity", position = position_dodge(), width = 0.75) +
  scale_x_discrete(name = "Year") +
  scale_y_continuous(name = "Annual growth (%)", limits = c(-60,60), 
                     expand = c(0,0), breaks = seq(-50,50, by = 10)) +
  scale_fill_manual(labels = c("Abkhazia", "Georgia (predicted)"),
                    values = c("#fc9272", "#A6CEE3")) +
  theme(legend.title = element_blank(),
        legend.text = element_text(size = 10),
        legend.position = "top",
        legend.spacing.x = unit(0.2, "cm"),
        legend.margin = margin(b = -0.15, unit = "cm"),
        axis.title.x = element_text(size = 10, vjust = -0.5),
        axis.title.y = element_text(size = 10, vjust = 1),
        axis.text.x = element_text(angle = 70, vjust = 0.5),
        panel.grid.major.x = element_blank(),
        panel.grid.minor = element_blank())

ggsave("a_output/plot_growth_hat_ABK.png")

# plot GEO_SOS
geo_sos <- fulldata %>% 
  subset(territory == "GEO (predicted)" | territory == "SOS")

geo_sos$year <- as.factor(geo_sos$year)

geo_sos$territory <- factor(geo_sos$territory, levels = c("SOS", "GEO (predicted)"))

geo_sos %>% 
  ggplot(aes(x = year, y = growth, fill = territory)) +
  geom_bar(stat = "identity", position = position_dodge(), width = 0.75) +
  scale_x_discrete(name = "Year") +
  scale_y_continuous(name = "Annual growth (%)", limits = c(-60,60), 
                     expand = c(0,0), breaks = seq(-50,50, by = 10)) +
  scale_fill_manual(labels = c("South Ossetia", "Georgia (predicted)"),
                    values = c("#fc9272", "#A6CEE3")) +
  theme(legend.title = element_blank(),
        legend.text = element_text(size = 10),
        legend.position = "top",
        legend.spacing.x = unit(0.2, "cm"),
        legend.margin = margin(b = -0.15, unit = "cm"),
        axis.title.x = element_text(size = 10, vjust = -0.5),
        axis.title.y = element_text(size = 10, vjust = 1),
        axis.text.x = element_text(angle = 70, vjust = 0.5),
        panel.grid.major.x = element_blank(),
        panel.grid.minor = element_blank())

ggsave("a_output/plot_growth_hat_SOS.png")

# plot MDA_TRA
mda_tra <- fulldata %>% 
  subset(territory == "MDA (predicted)" | territory == "TRA")

mda_tra$year <- as.factor(mda_tra$year)

mda_tra$territory <- factor(mda_tra$territory, levels = c("TRA", "MDA (predicted)"))

mda_tra %>% 
  ggplot(aes(x = year, y = growth, fill = territory)) +
  geom_bar(stat = "identity", position = position_dodge(), width = 0.75) +
  scale_x_discrete(name = "Year") +
  scale_y_continuous(name = "Annual growth (%)", limits = c(-60,60), 
                     expand = c(0,0), breaks = seq(-50,50, by = 10)) +
  scale_fill_manual(labels = c("Transnistria", "Moldova (predicted)"),
                    values = c("#fc9272", "#A6CEE3")) +
  theme(legend.title = element_blank(),
        legend.text = element_text(size = 10),
        legend.position = "top",
        legend.spacing.x = unit(0.2, "cm"),
        legend.margin = margin(b = -0.15, unit = "cm"),
        axis.title.x = element_text(size = 10, vjust = -0.5),
        axis.title.y = element_text(size = 10, vjust = 1),
        axis.text.x = element_text(angle = 70, vjust = 0.5),
        panel.grid.major.x = element_blank(),
        panel.grid.minor = element_blank())

ggsave("a_output/plot_growth_hat_TRA.png")

# plot AZE_NKR
aze_nkr <- fulldata %>% 
  subset(territory == "AZE (predicted)" | territory == "NKR")

aze_nkr$year <- as.factor(aze_nkr$year)

aze_nkr$territory <- factor(aze_nkr$territory, levels = c("NKR", "AZE (predicted)"))

aze_nkr %>% 
  ggplot(aes(x = year, y = growth, fill = territory)) +
  geom_bar(stat = "identity", position = position_dodge(), width = 0.75) +
  scale_x_discrete(name = "Year") +
  scale_y_continuous(name = "Annual growth (%)", limits = c(-60,60), 
                     expand = c(0,0), breaks = seq(-50,50, by = 10)) +
  scale_fill_manual(labels = c("Nagorno-Karabakh", "Azerbaijan (predicted)"),
                    values = c("#fc9272", "#A6CEE3")) +
  theme(legend.title = element_blank(),
        legend.text = element_text(size = 10),
        legend.position = "top",
        legend.spacing.x = unit(0.2, "cm"),
        legend.margin = margin(b = -0.15, unit = "cm"),
        axis.title.x = element_text(size = 10, vjust = -0.5),
        axis.title.y = element_text(size = 10, vjust = 1),
        axis.text.x = element_text(angle = 70, vjust = 0.5),
        panel.grid.major.x = element_blank(),
        panel.grid.minor = element_blank())

ggsave("a_output/plot_growth_hat_NKR.png")
