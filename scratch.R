library(shiny)
library(ggplot2)
library(dplyr)
library(tidyverse)

deforestationData <- read.csv("Deforestation/data/annual-change-forest-area.csv")
sqAreaData <- read.csv("Deforestation/data/landArea.csv")

sqArea <- sqAreaData%>%
  select(Country.Name, X2005) %>%
  rename(Entity = Country.Name, totalArea = X2005) %>%
  mutate(totalArea = totalArea * 1000)
  

dfrstn <- deforestationData %>%
  select(Entity, Year, Net.forest.conversion) %>%
  rename(netForestChange = Net.forest.conversion)

dfrstn <- left_join(sqArea, dfrstn, by = "Entity" )

wide = dfrstn %>%
  spread(Year, netForestChange)

wide <- wide %>%
  select(Entity, totalArea, "1990", "2000", "2010", "2015") %>%
  na.omit()

wide1 <- wide %>%
  slice_head()

dfrstn <- dfrstn %>%
  mutate(percentChange = (netForestChange/totalArea) * 100) %>%
  arrange(desc(percentChange))

dfrstnLine <- dfrstn %>%
  na.omit()

dfrstn15 <- dfrstn %>%
  filter(Year == 2015) %>%
  arrange(desc(percentChange))

ArgentinaDeforestation <- dfrstn %>%
  filter(Entity == "Argentina") 
  
worldDeforestation <- dfrstn %>%
  filter(Entity == "World")
  
ggplot(data=worldDeforestation, aes(x=Year, y=netForestChange, group=1)) +
  geom_line()+
  geom_point()

head(dfrstn15)
