library(shiny)
library(ggplot2)
library(dplyr)
library(tidyverse)
require(maps)

deforestationData <- read.csv("Deforestation/data/annual-change-forest-area.csv")
sqAreaData <- read.csv("Deforestation/data/landArea.csv")
aff <- read.csv("Deforestation/data/agricultureFishingForestry(%GDP).csv")
gcf <- read.csv("Deforestation/data/grossCapitalFormation(%GDP).csv")


dfrstn <- deforestationData %>%
  select(Entity, Year, Net.forest.conversion) %>%
  rename(netForestChange = Net.forest.conversion)
 
  
sqArea <- sqAreaData%>%
  select(Country.Name, X2005) %>%
  rename(Entity = Country.Name, totalArea = X2005) %>%
  mutate(totalArea = totalArea * 1000) %>%
  mutate(Entity = replace(Entity, Entity == "United States", "USA"))

world_map <- map_data("world")

sqAreaLuke <- sqArea 

aff <- aff %>% 
  select(Country.Name, X2005) %>%
  rename(region = Country.Name, aff = X2005)

gcf <- gcf %>% 
  select(Country.Name, X2005) %>% 
  rename(region = Country.Name, gcf = X2005)

dfrstn <- left_join(sqArea, dfrstn, by = "Entity" )

dfrstn <- dfrstn %>%
  mutate(percentChange = (netForest/totalArea) * 100)

dfrstnForMap <- dfrstn %>%
  rename(region = Entity)

dfrstn15 <- dfrstnForMap %>%
  filter(Year == 2015)

dfrstn00 <- dfrstnForMap %>%
  filter(Year == 2000)

dfrstn10 <- dfrstnForMap %>%
  filter(Year == 2010)

dfrstn90 <- dfrstnForMap %>%
  filter(Year == 1990)

aff <- left_join(aff, gcf, by = "region")
Indicators <- left_join(dfrstnForMap, aff, by = "region")

Indicators <- Indicators %>%
  rename(netForest = netForestChange) %>%
  na.omit()

ggplot(Indicators, aes(x = aff, y = percentChange)) +
  geom_point() +
  geom_smooth(method="lm") +
  xlim(15, 30) +
  ylim(-.1, .1)

ggplot(Indicators, aes(x = gcf, y = percentChange)) +
  geom_point() +
  geom_smooth(method="lm") +
  xlim(15, 30) +
  ylim(-.1, .1)
dfrstn15Map <- left_join(world_map,dfrstn15, by = "region")
dfrstn10Map <- left_join(world_map,dfrstn10, by = "region")
dfrstn00Map <- left_join(world_map,dfrstn00, by = "region")
dfrstn90Map <- left_join(world_map,dfrstn90, by = "region")

ggplot(dfrstn90Map, aes(long, lat, group = group))+
  geom_polygon(aes(fill=netForestChange), 
               color = "white") +
scale_fill_gradient(high = "green", low= "red", name="Net Forestation Change", 
                        labels = c("-4mil Hectares", "-3mil Hectares", "-2mil Hectares", "-1mil Hectares", "Zero Net Change", "+1mil Hectares", "+2mil Hectares", "+3mil Hectares", "+4mil Hectares"),
                        breaks = c(-4000000, -3000000, -2000000, -1000000, 0, 1000000, 2000000, 3000000, 4000000))

ggplot(dfrstn90Map, aes(long, lat, group = group))+
  geom_polygon(aes(fill=percentChange), 
               color = "white") +
  scale_fill_gradient(high = "green", low= "red", name="Percent of Country Forestation Change", 
                      labels = c("-.1% Loss","-.05% Loss", "No net loss",".05% Gain",".1% Gain"),
                      breaks = c(-0.1, -.05, 0, .05, .1))

