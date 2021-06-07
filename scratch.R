install.packages("shiny", "ggplot2", "dplyr", "tidyverse", "ggpubr", "maps")

library(shiny)
library(ggplot2)
library(dplyr)
library(tidyverse)
require(maps)
library(ggpubr)

deforestationData <- read.csv("data/annual-change-forest-area.csv") %>%
  select(Entity, Year, Net.forest.conversion) %>%
  rename(netForestChange = Net.forest.conversion)

sqAreaData <- read.csv("data/landArea.csv") %>%
  select(Country.Name, X2005) %>%
  rename(Entity = Country.Name, totalArea = X2005) %>%
  mutate(totalArea = totalArea * 100)

agricultureFishingForestry <- read.csv("data/agriculture-fishing-forestry-gdp.csv") %>%
  select(Country.Name, X2005) %>%
  rename(Entity = Country.Name, aFF = X2005)

grossCapitalFormation <- read.csv("data/gross-capital-formation-gdp.csv") %>%
  select(Country.Name, X2005) %>%
  rename(Entity = Country.Name, cFF = X2005)

agriculturalPercentOfLand <- read.csv("data/agricultural-percent-of-land.csv") %>%
  select(Country.Name, X2005) %>%
  rename(Entity = Country.Name, aPL = X2005)

cropProductionIndex <- read.csv("data/crop-production-index.csv") %>%
  select(Country.Name, X2005) %>%
  rename(Entity = Country.Name, cPI = X2005)

livestockProductionIndex <- read.csv("data/livestock-production-index.csv") %>%
  select(Country.Name, X2005) %>%
  rename(Entity = Country.Name, lPI = X2005)

co2Emissions <- read.csv("data/co2Emissions.csv") %>%
  select(Country.Name, X2005) %>%
  rename(Entity = Country.Name, CO2Emissions = X2005)

methaneEmissions <- read.csv("data/methane-emisions.csv") %>%
  select(Country.Name, X2005) %>%
  rename(Entity = Country.Name, methaneEmissions = X2005)

nitrousOxideEmissions <- read.csv("data/nitrous-oxide-emisions.csv") %>%
  select(Country.Name, X2005) %>%
  rename(Entity = Country.Name, nitOxEmission = X2005)
  
world_map <- map_data("world")



dfrstnIndicators <- left_join(sqAreaData, deforestationData, by = "Entity" ) %>%
  mutate(percentChange = (netForestChange/totalArea) * 100)

dfrstnIndicators <- left_join(dfrstnIndicators, agricultureFishingForestry, by = "Entity" )
dfrstnIndicators <- left_join(dfrstnIndicators, grossCapitalFormation, by = "Entity" )
dfrstnIndicators <- left_join(dfrstnIndicators, agriculturalPercentOfLand, by = "Entity" )
dfrstnIndicators <- left_join(dfrstnIndicators, cropProductionIndex, by = "Entity" )
dfrstnIndicators <- left_join(dfrstnIndicators, livestockProductionIndex, by = "Entity" )
dfrstnIndicators <- left_join(dfrstnIndicators, co2Emissions, by = "Entity" )
dfrstnIndicators <- left_join(dfrstnIndicators, methaneEmissions, by = "Entity" )
dfrstnIndicators <- left_join(dfrstnIndicators, nitrousOxideEmissions, by = "Entity" )


dfrstn10Indicators <- dfrstnIndicators %>%
  filter(totalArea < 942469981, Year == 2010)

dfrstn00Indicators <- dfrstnIndicators %>%
  filter(totalArea < 942469981, Year == 2010)
dfrstn90Indicators <- dfrstnIndicators %>%
  filter(totalArea < 942469981, Year == 2010)
dfrstn15Indicators <- dfrstnIndicators %>%
  filter(totalArea < 942469981, Year == 2010)
  


sqAreaLuke <- sqArea 
dfrstn <- dfrstn %>%
  mutate(percentChange = (netForest/totalArea) * 100)

chloeDef <- dfrstn %>% 
  filter(Year == "2000") %>% 
  arrange(netForestChange) %>% 
  head(5)

dfrstnForMap <- dfrstn %>%
  rename(region = Entity)

dfrstnForChart <- dfrstn %>%
  filter(Entity != "World") 

print(c(unique(dfrstnForChart$Entity)))
  


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

lm_eqn <- function(df){
  m <- lm(percentChange ~ aFF, df);
  eq <- substitute(italic(netForestChange) == a + b %.% italic(aFF)*","~~italic(r)^2~"="~r2, 
                   list(a = format(unname(coef(m)[1]), digits = 2),
                        b = format(unname(coef(m)[2]), digits = 2),
                        r2 = format(summary(m)$r.squared, digits = 3)))
  as.character(as.expression(eq));
}

cor.test(dfrstnIndicators$netForestChange, dfrstnIndicators$CO2Emissions,  method = "pearson", conf.level = 0.95)
print(summary(lm(netForestChange ~ CO2Emissions/totalArea, dfrstn10Indicators))$r.squared * 100, digits = 3)


ggplot(dfrstnIndicators, aes(x = CO2Emissions, y = netForestChange)) +
  geom_point() +
  geom_smooth(method="lm") +
  stat_cor(aes(label = paste(..rr.label..)))

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

