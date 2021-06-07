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
    rename(Entity = Country.Name, gCF = X2005)

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

cerealDevelopment <- read.csv("data/cerealProduction.csv") %>%
    select(Country.Name, X2005) %>%
    rename(Entity = Country.Name, cereal = X2005)

forestArea <- read.csv("data/forestArea.csv") %>%
    select(Country.Name, X2005) %>%
    rename(Entity = Country.Name, forestArea = X2005)

dfrstnIndicators <- left_join(sqArea, deforestationData, by = "Entity" ) %>%
    mutate(percentChange = (netForestChange/totalArea) * 100)

dfrstnIndicators <- left_join(dfrstnIndicators, agricultureFishingForestry, by = "Entity" )
dfrstnIndicators <- left_join(dfrstnIndicators, grossCapitalFormation, by = "Entity" )
dfrstnIndicators <- left_join(dfrstnIndicators, agriculturalPercentOfLand, by = "Entity" )
dfrstnIndicators <- left_join(dfrstnIndicators, cropProductionIndex, by = "Entity" )
dfrstnIndicators <- left_join(dfrstnIndicators, livestockProductionIndex, by = "Entity" )
dfrstnIndicators <- left_join(dfrstnIndicators, co2Emissions, by = "Entity" )
dfrstnIndicators <- left_join(dfrstnIndicators, methaneEmissions, by = "Entity" )
dfrstnIndicators <- left_join(dfrstnIndicators, cerealDevelopment, by = "Entity")
dfrstnIndicators <- left_join(dfrstnIndicators, forestArea, by = "Entity")

dfrstnIndicators <- dfrstnIndicators %>%
    filter(totalArea < 942469981) %>%
    mutate(Entity = replace(Entity, Entity == "United States", "USA"))

dfrstn <- deforestationData
dfrstnForMap <- dfrstnIndicators %>%
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
    
    output$value <- renderText({ 
        indicator <- input$keyIndicators
        if(indicator == "CO2Emissions"){
            "Carbon dioxide emissions are those stemming from the burning of fossil fuels and the manufacture of cement. They include carbon dioxide produced during consumption of solid, liquid, and gas fuels and gas flaring."
        } else if (indicator == "cereal"){
            print("Production data on cereals relate to crops harvested for dry grain only. Cereal crops harvested for hay or harvested green for food, feed, or silage and those used for grazing are excluded.")
        } else if (indicator == "methaneEmissions"){
            print("Methane emissions are those stemming from human activities such as agriculture and from industrial methane production.")
            
        } else if (indicator == "gCF"){
            print("Gross capital formation (formerly gross domestic investment) consists of outlays on additions to the fixed assets of the economy plus net changes in the level of inventories. Fixed assets include land improvements (fences, ditches, drains, and so on); plant, machinery, and equipment purchases; and the construction of roads, railways, and the like, including schools, offices, hospitals, private residential dwellings, and commercial and industrial buildings. Inventories are stocks of goods held by firms to meet temporary or unexpected fluctuations in production or sales, and 'work in progress.' According to the 1993 SNA, net acquisitions of valuables are also considered capital formation.")
            
        } else if (indicator == "forestArea"){
            print("Forest area is land under natural or planted stands of trees of at least 5 meters in situ, whether productive or not, and excludes tree stands in agricultural production systems (for example, in fruit plantations and agroforestry systems) and trees in urban parks and gardens.")
        } else if (indicator == "aPL"){
            print("Agricultural land refers to the share of land area that is arable, under permanent crops, and under permanent pastures. Arable land includes land defined by the FAO as land under temporary crops (double-cropped areas are counted once), temporary meadows for mowing or for pasture, land under market or kitchen gardens, and land temporarily fallow.")
        } else if (indicator == "cPI"){
            print("Crop production index shows agricultural production for each year relative to the base period 2014-2016. It includes all crops except fodder crops. Regional and income group aggregates for the FAO's production indexes are calculated from the underlying values in international dollars, normalized to the base period 2014-2016.")
        } else if (indicator == "aFF"){
            print("Agriculture corresponds to ISIC divisions 1-5 and includes forestry, hunting, and fishing, as well as cultivation of crops and livestock production. Value added is the net output of a sector after adding up all outputs and subtracting intermediate inputs. It is calculated without making deductions for depreciation of fabricated assets or depletion and degradation of natural resources. The origin of value added is determined by the International Standard Industrial Classification (ISIC), revision 3. Note: For VAB countries, gross value added at factor cost is used as the denominator.")
        } else if (indicator == "lPI"){
            print("Livestock production index includes meat and milk from all sources, dairy products such as cheese, and eggs, honey, raw silk, wool, and hides and skins.")
        }   
        })
    output$indicatorPlot <- renderPlot({
            indicator <- input$keyIndicators
            dependent <- input$netPercent
            print(dependent)
            if (dependent == "netForestChange"){
                labTitle = "Change of Net Forest Cover"
                yStr = "Annual Net Change of Forest Cover"
            } else{
                labTitle = "Change of Forest Cover Percentage"
                yStr = "Annual Percentage Change of Forest Cover"
            }
        if(indicator == "CO2Emissions"){
            subTitle = "Measured against carbon dioxide emissions"
            xStr = "CO2 Emissions"
        } else if (indicator == "cereal"){
            subTitle = "Measured against production of crops harvested for dry grain"
            xStr = "Cereal production (metric tons)" 
        } else if (indicator == "methaneEmissions"){
            subTitle = "Measured against methane emissions"
            xStr = "Methane emissions (kt of CO2 equivalent)" 
        } else if (indicator == "gCF"){
            subTitle = "Measured against Gross Capital Formation"
            xStr = "Gross capital formation (% of GDP)" 
        } else if (indicator == "forestArea"){
            subTitle = "Measured against Percentage of Area Forested"
            xStr = "Forest area (% of land area)" 
        } else if (indicator == "aPL"){
            subTitle = "Measured against average percent of land devoted to Agriculture"
            xStr = "Agricultural land (% of land area)" 
        } else if (indicator == "cPI"){
            subTitle = "Measured against Crop Production Index"
            xStr = "Crop Production Index" 
        } else if (indicator == "aFF"){
            subTitle = "Measured against Agriculture, Fishing, & Forestry Industries"
            xStr = "Agriculture, forestry, and fishing, value added (% of GDP)" 
        } else if (indicator == "lPI"){
            subTitle = "Measured against the Livestock Production Index"
            xStr = "Livestock Production Index" 
        }   
            ggplot(dfrstnIndicators, aes_string(x = indicator, y = dependent)) +
                geom_point() +
                geom_smooth(method="lm") +
                stat_cor(aes(label = paste(..rr.label..))) + 
                labs(title = labTitle, subtitle = subTitle) +
                labs(x = xStr,
                     y = yStr)
                
        
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
            dfrstnIndicators %>% 
                filter(Year == input$yearChoice, Entity != "World") %>% 
                arrange(netForestChange) %>% 
                head(5)
        } else {
            dfrstnIndicators %>% 
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
