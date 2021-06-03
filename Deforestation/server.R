#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(dplyr)
library(tidyverse)
require(maps)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
deforestationData <- read.csv("data/annual-change-forest-area.csv")
sqAreaData <- read.csv("data/landArea.csv")
aff <- read.csv("data/agriculture-fishing-forestry-gdp.csv")
gcf <- read.csv("data/gross-capital-formation-gdp.csv")

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
    mutate(percentChange = (netForestChange/totalArea) * 100)

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


ggplot(Indicators, aes(x = gcf, y = percentChange)) +
    geom_point() +
    geom_smooth(method="lm") +
    xlim(15, 30) +
    ylim(-.1, .1)
dfrstn15Map <- left_join(world_map,dfrstn15, by = "region")
dfrstn10Map <- left_join(world_map,dfrstn10, by = "region")
dfrstn00Map <- left_join(world_map,dfrstn00, by = "region")
dfrstn90Map <- left_join(world_map,dfrstn90, by = "region")

    output$distPlot <- renderPlot({
        
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)
        
        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')
    })
    
    output$plot = renderPlot({
        ggplot(dfrstn[ which(dfrstn$Entity==input$country),], aes(x=Year, y=netForestChange, group=1)) +
            geom_line()+
            geom_point() +
            labs(title = "Change of Net Forest Cover by Coutry", subtitle = "Measured in Hectares") +
            labs(x = "Year of Measurement for Net Change",
                 y = "Annual Net Change of Forest Cover (in Hectares)")
    })
    
    output$mainMap <- renderPlot({
        data = dfrstn15Map
        fillChoice = "netForestChange"
        
        ggplot(data, aes(long, lat, group = group))+
            geom_polygon(aes_string(fill= fillChoice), 
                         color = "white") +
            scale_fill_gradient(high = "green", low= "red", name="Net Forestation Change", 
                                labels = c("-4mil Hectares", "-3mil Hectares", "-2mil Hectares", "-1mil Hectares", "Zero Net Change", "+1mil Hectares", "+2mil Hectares", "+3mil Hectares", "+4mil Hectares"),
                                breaks = c(-4000000, -3000000, -2000000, -1000000, 0, 1000000, 2000000, 3000000, 4000000))
        
    })
    output$heatMap <- renderPlot({
        data = switch(input$yearChoice,
                      "1990" = dfrstn90Map,
                      "2000" = dfrstn00Map,
                      "2010" = dfrstn10Map,
                      "2015" = dfrstn15Map)
        
        fillChoice = switch(input$percentageChoice,
                      "net" = "netForestChange",
                      "percentage" = "percentChange")
        
        ggplot(data, aes(long, lat, group = group))+
            geom_polygon(aes_string(fill= fillChoice), 
                         color = "white") +
            scale_fill_gradient(high = "green", low= "red", name="Net Forestation Change", 
                                labels = c("-4mil Hectares", "-3mil Hectares", "-2mil Hectares", "-1mil Hectares", "Zero Net Change", "+1mil Hectares", "+2mil Hectares", "+3mil Hectares", "+4mil Hectares"),
                                breaks = c(-4000000, -3000000, -2000000, -1000000, 0, 1000000, 2000000, 3000000, 4000000))
    })
    output$affPlot <- renderPlot({
        ggplot(Indicators, aes(x = aff, y = percentChange)) +
            geom_point() +
            geom_smooth(method="lm") +
            xlim(15, 30) +
            ylim(-.1, .1) +
            labs(title = "Change of Forest Cover Percentage by Country", subtitle = "Measured against Agriculture, Fishing, & Forestry Industries") +
            labs(x = "Agriculture, Fishing, & Forestry Industries as % of GDP",
                 y = "Annual Percentage Change of Forest Cover")
        
    })
    
    output$gcfPlot <- renderPlot({
        ggplot(Indicators, aes(x = gcf, y = percentChange)) +
            geom_point() +
            geom_smooth(method="lm") +
            xlim(15, 30) +
            ylim(-.1, .1) +
            labs(title = "Change of Forest Cover Percentage by Country", subtitle = "Measured against Gross Capital Formation") +
            labs(x = "Gross Capital Formation as % of GDP",
                 y = "Annual Percentage Change of Forest Cover")
        
    })
    
    
    
})
