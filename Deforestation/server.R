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
library(ECharts2Shiny)

deforestationData <- read.csv("data/annual-change-forest-area.csv")
sqAreaData <- read.csv("data/landArea.csv")

sqArea <- sqAreaData%>%
    select(Country.Name, X2005) %>%
    rename(Entity = Country.Name, totalArea = X2005) %>%
    mutate(totalArea = totalArea * 1000)


dfrstn <- deforestationData %>%
    select(Entity, Year, Net.forest.conversion) %>%
    rename(netForestChange = Net.forest.conversion)

dfrstn <- left_join(sqArea, dfrstn, by = "Entity" )

dfrstn <- dfrstn %>%
    mutate(percentChange = (netForestChange/totalArea) * 100) %>%
    arrange(desc(percentChange))

dfrstnLine <- dfrstn %>%
    na.omit()

lukeData <- dfrstn %>%
    na.omit() %>%
    rename(aff = netForestChange, gcf = percentChange) 

print(head(lukeData))


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    
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
    output$Lukeplot = renderPlot({
        ggplot(lukeData, aes_string(x = input$indicatorSelect, y = totalArea)) +
            geom_point() +
            xlim(0, 30) +
            ylim(-150000, 150000) 
    })
    
    
})
