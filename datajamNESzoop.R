################################################################################
#############             Zooplankton Abundance                #################
#############                 NES-LTER  DATA JAM               #################
#############                     NOV-2024                     #################
## by: Alexandra Cabanelas 
################################################################################
# creating data for Data JAM
# zooplankton abundance by station 

## ------------------------------------------ ##
#            Packages -----
## ------------------------------------------ ##
library(tidyverse)

## ------------------------------------------ ##
#            Data -----
## ------------------------------------------ ##

zp <- read.csv(file.path("raw",
                         "nes-lter-zp-abundance-335um-unstaged100m3.csv"), 
               header = T) #created in \NES-LTER\Cruise Data\EDI zooplankton abundance update v2\zoop_abundance_update_EDI_v2

station_info <- read.csv(file.path("raw",
                                   "nes-lter-station-coordinates.csv"), 
                         header = T) #from the abundance package folder

## ------------------------------------------ ##
#            Tidy -----
## ------------------------------------------ ##
zp <- zp %>%
  filter(station != "u11c")

zp$station <- factor(zp$station, level = c('MVCO', 'L1', 'L2',
                                           'L3', 'L4', 'L5',
                                           'L6', 'L7', 'L8',
                                           'L9', 'L10', 'L11'))

station_info$station <- factor(station_info$station, level = c('MVCO', 'L1', 'L2',
                                           'L3', 'L4', 'L5',
                                           'L6', 'L7', 'L8',
                                           'L9', 'L10', 'L11'))

# create month column 
# convert event_date to posixct format
zp$datetime_utc <- as.POSIXct(zp$datetime_utc, 
                              format = "%Y-%m-%d %H:%M:%S", 
                              tz = "UTC")

# Extract month and year from datetime_utc
zp$month <- as.numeric(format(zp$datetime_utc, "%m"))
zp$year <- as.numeric(format(zp$datetime_utc, "%Y"))

zp <- zp %>%
  mutate(season = case_when(
    month %in% c(12, 1, 2) ~ "winter",
    month %in% c(3, 4, 5) ~ "spring",
    month %in% c(6, 7, 8) ~ "summer",
    month %in% c(9, 10, 11) ~ "fall"))


## ------------------------------------------ ##
#            Summary -----
## ------------------------------------------ ##

# top 6 taxa overall 
top_taxa <- zp %>%
  group_by(taxa_name) %>%
  summarise(total_conc_100m3 = sum(conc_100m3, na.rm = TRUE)) %>%
  arrange(desc(total_conc_100m3)) %>%
  slice_head(n = 6) # Select top 6 taxa

zp_top_taxa <- zp %>%
  filter(taxa_name %in% top_taxa$taxa_name)

# group taxa by station
zp1_top_taxa <- zp_top_taxa %>%
  group_by(station, taxa_name) %>%
  summarise(mean_conc_100m3 = mean(conc_100m3, na.rm = TRUE)) %>%
  ungroup()


#top taxa by station
aggregated_data <- zp %>%
  group_by(station, taxa_name) %>%
  summarise(total_conc_100m3 = sum(conc_100m3, na.rm = TRUE), 
            .groups = "drop") # Sum across years

top_taxa_per_station <- aggregated_data %>%
  group_by(station) %>%
  arrange(desc(total_conc_100m3), .by_group = TRUE) %>% 
  slice_head(n = 3) %>% # Select top 3 taxa per station
  ungroup()

top_taxa_per_station %>%
  select(station, taxa_name) %>% print(n = 39)

top_taxa_per_station %>%
  count(taxa_name, sort = TRUE)

## ------------------------------------------ ##
#            PLOT -----
## ------------------------------------------ ##

tableau_colors <- c("#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd", 
                    "#8c564b", "#e377c2", "#7f7f7f", "#bcbd22", "#17becf", 
                    "#f9a8d4", "#56a5d1", "#f5c07f", "#88e2a8", "#d89f91", 
                    "#c9c9c9", "#c2b9f7", "#f8c2c1", "#ffda77", "#fd8752")

# total abundance 
ggplot(zp1_top_taxa, aes(station, mean_conc_100m3, 
                         group = taxa_name, fill = taxa_name)) +
  geom_bar(stat = "identity") +
  labs(x="Station") +
  ylab(expression("Density (Ind \u00D7 100" ~ m^{3} ~ ")")) +
  theme_bw() +
  scale_fill_manual(values = tableau_colors) +
  theme(legend.position = "right",
        plot.title = element_text(hjust=0.5, face = "bold", 
                                  size = 15),
        legend.title = element_blank(),
        legend.text = element_text(size = 10),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.title.x = element_text(size = 14,
                                    color = "black"),
        axis.title.y = element_text(size = 14,
                                    color = "black"),
        axis.text.x = element_text(color = "black", 
                                   size = 12, angle = 45, hjust = 1),
        axis.text.y = element_text(color = "black", 
                                   size = 12),
        axis.ticks.length = unit(0.2,"cm"),
        plot.caption.position =  "plot",
        plot.caption = element_text(size = 12)) +
  scale_y_continuous(expand = expansion(mult = c(0,0.1)))

# relative abundance
ggplot(zp1_top_taxa, aes(station, mean_conc_100m3, 
                         group = taxa_name, fill = taxa_name)) +
  geom_col(position = "fill") +
  labs(x="Station") +
  ylab(expression("Density (Ind \u00D7 100" ~ m^{3} ~ ")")) +
  theme_bw() +
  scale_fill_manual(values = tableau_colors) +
  theme(legend.position = "right",
        plot.title = element_text(hjust=0.5, face = "bold", 
                                  size = 15),
        legend.title = element_blank(),
        legend.text = element_text(size = 10),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.title.x = element_text(size = 14,
                                    color = "black"),
        axis.title.y = element_text(size = 14,
                                    color = "black"),
        axis.text.x = element_text(color = "black", 
                                   size = 12, angle = 45, hjust = 1),
        axis.text.y = element_text(color = "black", 
                                   size = 12),
        axis.ticks.length = unit(0.2,"cm"),
        plot.caption.position =  "plot",
        plot.caption = element_text(size = 12)) +
  scale_y_continuous(labels = scales::percent, 
                     expand = expansion(mult = c(0,0.01)))

## ------------------------------------------ ##
#            Freq Occurrence -----
## ------------------------------------------ ##

# Step 1: Count the total number of unique sampling events
total_samples <- zp %>%
  distinct(cruise, station, cast) %>% # Unique combination of cruise, station, and cast (one sample)
  count()

# Step 2: Count how many times each species appears in unique sampling events
species_occurrences <- zp %>%
  filter(conc_100m3 > 0) %>%  # Filter only records where concentration is greater than zero
  distinct(cruise, station, cast, taxa_name) %>% # Unique combination of species in a sample
  count(taxa_name)

# Step 3: Calculate the frequency of occurrence (number of occurrences / total samples)
frequency_of_occurrence <- species_occurrences %>%
  mutate(frequency = n / total_samples$n) %>%
  arrange(desc(frequency))

# View the results
frequency_of_occurrence


## ------------------------------------------ ##
#            Final Data -----
## ------------------------------------------ ##

taxa_of_interest <- c("Calanus finmarchicus", 
                      "Centropages typicus", 
                      "Chaetognatha", 
                      "Oithona", 
                      "Pseudocalanus minutus", 
                      "Acartia")
#Paracalanus parvus; thaliacea

filtered_zp <- zp %>%
  filter(taxa_name %in% taxa_of_interest)

filtered_zp1 <- filtered_zp %>%
  group_by(station, taxa_name) %>%
  summarise(mean_conc_100m3 = mean(conc_100m3, na.rm = TRUE)) %>%
  ungroup()

ggplot(filtered_zp1, aes(station, mean_conc_100m3, 
                         group = taxa_name, fill = taxa_name)) +
  geom_bar(stat = "identity") +
  labs(x="Station") +
  #facet_wrap(~season) +
  ylab(expression("Density (Ind \u00D7 100" ~ m^{3} ~ ")")) +
  theme_bw() +
  scale_fill_manual(values = tableau_colors) +
  theme(legend.position = "right",
        plot.title = element_text(hjust=0.5, face = "bold", 
                                  size = 15),
        legend.title = element_blank(),
        legend.text = element_text(size = 10),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.title.x = element_text(size = 14,
                                    color = "black"),
        axis.title.y = element_text(size = 14,
                                    color = "black"),
        axis.text.x = element_text(color = "black", 
                                   size = 12, angle = 45, hjust = 1),
        axis.text.y = element_text(color = "black", 
                                   size = 12),
        axis.ticks.length = unit(0.2,"cm"),
        plot.caption.position =  "plot",
        plot.caption = element_text(size = 12)) +
  scale_y_continuous(expand = expansion(mult = c(0,0.01)))



ggplot(filtered_zp1, aes(station, mean_conc_100m3, 
                         group = taxa_name, fill = taxa_name)) +
  geom_col(position = "fill") +
  labs(x="Station") +
  #facet_wrap(~season) +
  ylab(expression("Density (Ind \u00D7 100" ~ m^{3} ~ ")")) +
  theme_bw() +
  scale_fill_manual(values = tableau_colors) +
  theme(legend.position = "right",
        plot.title = element_text(hjust=0.5, face = "bold", 
                                  size = 15),
        legend.title = element_blank(),
        legend.text = element_text(size = 10),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.title.x = element_text(size = 14,
                                    color = "black"),
        axis.title.y = element_text(size = 14,
                                    color = "black"),
        axis.text.x = element_text(color = "black", 
                                   size = 12, angle = 45, hjust = 1),
        axis.text.y = element_text(color = "black", 
                                   size = 12),
        axis.ticks.length = unit(0.2,"cm"),
        plot.caption.position =  "plot",
        plot.caption = element_text(size = 12)) +
  scale_y_continuous(labels = scales::percent,
                     expand = expansion(mult = c(0,0.01)))

filtered_zp1 <- merge(filtered_zp1, station_info, 
                      by = "station", 
                      all.x = TRUE)

filtered_zp1 <- filtered_zp1 %>%
  mutate(mean_conc_m3 = mean_conc_100m3/100) %>%
  select(-mean_conc_100m3) %>%
  select(station, taxa_name, mean_conc_m3, everything())

filtered_zp2 <- filtered_zp1 %>%
  rename(Station = station, 
         Latitude = lat,
         Longitude = lon,
         "Station Depth (m)" = depth_m,
         Zooplankton = taxa_name,
         Abundance = mean_conc_m3)

filtered_zp2 <- filtered_zp2 %>%
  arrange(Station)

#writecsv
#write.csv(filtered_zp2, "zooplankton_dataJam_m3.csv")

################################################################
################################################################
################################################################

################################################################
################################################################
################################################################
## 
################################################################
################################################################
################################################################
##  EXTRA
################################################################
################################################################
################################################################
## seasonality

taxa_of_interest_season <- c("Calanus finmarchicus", 
                      "Centropages typicus", 
                      "Chaetognatha", 
                      "Oithona", 
                      "Pseudocalanus minutus", 
                      "Acartia",
                      "Penilia avirostris",
                      "Hyperiidea")
#Paracalanus parvus; thaliacea

filtered_zp_season <- zp %>%
  filter(taxa_name %in% taxa_of_interest_season)

filtered_zp_season1 <- filtered_zp_season %>%
  group_by(season, taxa_name) %>%
  summarise(mean_conc_10m2 = mean(conc_10m2, na.rm = TRUE)) %>%
  ungroup()

ggplot(filtered_zp_season1, aes(season, mean_conc_10m2, 
                         group = taxa_name, fill = taxa_name)) +
  geom_bar(stat = "identity") +
  labs(x="Station") +
  #facet_wrap(~season) +
  ylab(expression("Density (Ind \u00D7 10" ~ m^{2} ~ ")")) +
  theme_bw() +
  scale_fill_manual(values = tableau_colors) +
  theme(legend.position = "right",
        plot.title = element_text(hjust=0.5, face = "bold", 
                                  size = 15),
        legend.title = element_blank(),
        legend.text = element_text(size = 10),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.title.x = element_text(size = 14,
                                    color = "black"),
        axis.title.y = element_text(size = 14,
                                    color = "black"),
        axis.text.x = element_text(color = "black", 
                                   size = 12, angle = 45, hjust = 1),
        axis.text.y = element_text(color = "black", 
                                   size = 12),
        axis.ticks.length = unit(0.2,"cm"),
        plot.caption.position =  "plot",
        plot.caption = element_text(size = 12)) +
  scale_y_continuous(expand = expansion(mult = c(0,0.01)))



ggplot(filtered_zp_season1, aes(season, mean_conc_10m2, 
                         group = taxa_name, fill = taxa_name)) +
  geom_col(position = "fill") +
  labs(x="Station") +
  #facet_wrap(~season) +
  ylab(expression("Density (Ind \u00D7 10" ~ m^{2} ~ ")")) +
  theme_bw() +
  scale_fill_manual(values = tableau_colors) +
  theme(legend.position = "right",
        plot.title = element_text(hjust=0.5, face = "bold", 
                                  size = 15),
        legend.title = element_blank(),
        legend.text = element_text(size = 10),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.title.x = element_text(size = 14,
                                    color = "black"),
        axis.title.y = element_text(size = 14,
                                    color = "black"),
        axis.text.x = element_text(color = "black", 
                                   size = 12, angle = 45, hjust = 1),
        axis.text.y = element_text(color = "black", 
                                   size = 12),
        axis.ticks.length = unit(0.2,"cm"),
        plot.caption.position =  "plot",
        plot.caption = element_text(size = 12)) +
  scale_y_continuous(labels = scales::percent,
                     expand = expansion(mult = c(0,0.01)))




##FREQ OCC
zp %>%
  group_by(station) %>%
  summarise(unique_cruises = n_distinct(cruise),  # Count unique cruises per station
            .groups = "drop")

taxa_occurrence <- zp %>%
  group_by(station, taxa_name) %>%
  # Count the number of samples where abundance > 0 for each taxa
  summarise(count = sum(conc_10m2 > 0, na.rm = TRUE), 
            total_samples = n(), # Total samples collected at each station for each taxa
            .groups = "drop") %>%
  mutate(taxa_percent = (count / total_samples) * 100) 




filtered_zp2 <- filtered_zp1 %>%
  rename(Station = station, 
         Zooplankton = taxa_name,
         Abundance = mean_conc_10m2) %>%
  left_join(taxa_occurrence %>%
              select(station, taxa_name, taxa_percent), 
            by = c("Station" = "station", "Zooplankton" = "taxa_name"))



