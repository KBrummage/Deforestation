#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel(
        h1("Net Forest Change", align = "center")
    ),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            selectizeInput("country",
                           "Select Country:",
                           choices = c("Bulgaria", 
                                       "Czech Republic",
                                       "Denmark",
                                       "Poland",
                                       "Sweden",
                                       "Norway",
                                       "World"),
                           selected = "World"
                           )  
            ),
    
        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(type = "tabs",
                        tabPanel("World Heat Map", tags$h2("my heat map is going here")),
                        tabPanel("Plot", plotOutput("plot")),
                        tabPanel("Chloe", tags$h2("maybe Chloe's chart here")),
                        tabPanel("Luke", tags$h2("maybe Luke's chart here"))
                        
            )
           
        )
    )
))
