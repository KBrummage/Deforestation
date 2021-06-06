#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
# install.packages("shiny", "ggplot2", "dplyr", "tidyverse", "ggpubr", "maps")
library(shiny)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(ggpubr)
require(maps)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
deforestationData <- read.csv("data/annual-change-forest-area.csv") %>%
    select(Entity, Year, Net.forest.conversion) %>%
    rename(netForestChange = Net.forest.conversion)

sqArea <- read.csv("data/landArea.csv") %>%
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

dfrstnIndicators <- left_join(sqArea, deforestationData, by = "Entity" ) %>%
    mutate(percentChange = (netForestChange/totalArea) * 100)

dfrstnIndicators <- left_join(dfrstnIndicators, agricultureFishingForestry, by = "Entity" )
dfrstnIndicators <- left_join(dfrstnIndicators, grossCapitalFormation, by = "Entity" )
dfrstnIndicators <- left_join(dfrstnIndicators, agriculturalPercentOfLand, by = "Entity" )
dfrstnIndicators <- left_join(dfrstnIndicators, cropProductionIndex, by = "Entity" )
dfrstnIndicators <- left_join(dfrstnIndicators, livestockProductionIndex, by = "Entity" )
dfrstnIndicators <- left_join(dfrstnIndicators, co2Emissions, by = "Entity" )
dfrstnIndicators <- left_join(dfrstnIndicators, methaneEmissions, by = "Entity" )
dfrstnIndicators <- left_join(dfrstnIndicators, nitrousOxideEmissions, by = "Entity" )

dfrstn <- deforestationData
dfrstnForMap <- dfrstn %>%
    na.omit() %>%
    rename(region = "Entity")


    
world_map <- map_data("world")

sqAreaLuke <- sqArea 

aff <- agricultureFishingForestry 

gcf <- grossCapitalFormation


dfrstn15 <- dfrstnForMap %>%
    filter(Year == 2015)

dfrstn00 <- dfrstnForMap %>%
    filter(Year == 2000)

dfrstn10 <- dfrstnForMap %>%
    filter(Year == 2010)

dfrstn90 <- dfrstnForMap %>%
    filter(Year == 1990)

ggplot(dfrstnIndicators, aes(x = gcf, y = percentChange)) +
    geom_point() +
    geom_smooth(method="lm") +
    xlim(15, 30) +
    ylim(-.1, .1)

dfrstn15Map <- left_join(world_map,dfrstn15, by = "region")
dfrstn10Map <- left_join(world_map,dfrstn10, by = "region")
dfrstn00Map <- left_join(world_map,dfrstn00, by = "region")
dfrstn90Map <- left_join(world_map,dfrstn90, by = "region")

output$plot = renderPlot({
    ggplot(dfrstn[ which(dfrstn$Entity==input$country),], aes(x=Year)) +
        geom_line(aes(y=netForestChange), color="darkred") +
            labs(title = "Change of Net Forest Cover by Coutry", subtitle = "Measured in Hectares") +
            labs(x = "Year of Measurement for Net Change",
                 y = "Annual Net Change of Forest Cover (in Hectares)")
    })

output$plot1 = renderPlot({
    ggplot(dfrstnIndicators[ which(dfrstnIndicators$Entity==input$country),], aes(x=Year)) +
        geom_line(aes(y=netForestChange), color="darkred") +
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
        ggplot(dfrstnIndicators, aes(x = aFF, y = percentChange)) +
            geom_point() +
            geom_smooth(method="lm") +
            xlim(15, 30) +
            ylim(-.1, .1) +
            labs(title = "Change of Forest Cover Percentage by Country", subtitle = "Measured against Agriculture, Fishing, & Forestry Industries") +
            labs(x = "Agriculture, Fishing, & Forestry Industries as % of GDP",
                 y = "Annual Percentage Change of Forest Cover")
        
    })
    
    output$gcfPlot <- renderPlot({
        ggplot(dfrstnIndicators, aes(x = cFF, y = percentChange)) +
            geom_point() +
            geom_smooth(method="lm") +
            xlim(15, 30) +
            ylim(-.1, .1) +
            labs(title = "Change of Forest Cover Percentage by Country", subtitle = "Measured against Gross Capital Formation") +
            labs(x = "Gross Capital Formation as % of GDP",
                 y = "Annual Percentage Change of Forest Cover")
        
    })
    
    ChloePlot <- reactive({
        if(input$percentageChloe == "net"){
                dfrstn %>% 
                    filter(Year == input$Year, Entity != "World") %>% 
                    arrange(netForestChange) %>% 
                    head(5)
            } else {
                dfrstn %>% 
                    filter(Year == input$Year, Entity != "World") %>% 
                    arrange(netForestChange) %>% 
                    head(5)
            }
    })
    
    heatChart <- reactive({
        if(input$percentageChoice == "net"){
            dfrstn %>% 
                filter(Year == input$yearChoice, Entity != "World") %>% 
                arrange(netForestChange) %>% 
                head(5)
        } else {
            dfrstn %>% 
                filter(Year == input$yearChoice, Entity != "World") %>% 
                arrange(netForestChange) %>% 
                head(5)
        }
    })
    
    output$heatChart <- renderPlot({
        if(input$percentageChoice == "net"){
            ggplot(heatChart(),aes(x = Entity, y = netForestChange)) +
                geom_bar(stat="identity", fill= "darkred", width = 0.7) +
                scale_y_reverse() +
                geom_text(aes(label=netForestChange), vjust=1.6, color="white", size=3.5) +
                labs(title = "Top 5 Countries with the most deforestation")
        } else{
            ggplot(heatChart(),aes(x = Entity, y = percentChange)) +
                geom_bar(stat="identity", fill= "darkred", width = 0.5) +
                scale_y_reverse() +
                labs(title = "Top 5 Countries with highest deforestation rate")
        }
    })
    output$barChart <- renderPlot({
        if(input$percentageChloe == "net"){
        ggplot(ChloePlot(),aes(x = Entity, y = netForestChange)) +
            geom_bar(stat="identity", fill= "darkred", width = 0.7) +
                scale_y_reverse() +
                geom_text(aes(label=netForestChange), vjust=1.6, color="white", size=3.5) +
            labs(title = "Top 5 Countries with the most deforestation")
        } else{
            ggplot(ChloePlot(),aes(x = Entity, y = percentChange)) +
                geom_bar(stat="identity", fill= "darkred", width = 0.5) +
                scale_y_reverse() +
                labs(title = "Top 5 Countries with highest deforestation rate")
            
        }
    })
    
    
    
})
