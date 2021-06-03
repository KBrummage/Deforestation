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
shinyUI(
    navbarPage("Gobal Deforestation Rates",
        tabPanel("Intro",
            fluidPage(
                titlePanel(
                    h1("Net Forest Change", align = "center")),
                    mainPanel(h2("Hello World"))
                )
            ),
        
        tabPanel("Global Heat Map",
            fluidPage(
                h1("Map of Global Deforestation Rates", align="center"),
                sidebarLayout(
                    sidebarPanel(
                        selectInput(inputId = "yearChoice", 
                                    label = "Select the Dataset Year of your choice", 
                                    choices = c("1990","2000", "2010", "2015")
                                    ),
                        selectInput(inputId = "percentageChoice", 
                                    label = "Select the Dataset as net or percentage loss", 
                                    choices = c("net", "percentage")
                                    )
                        ),
                    mainPanel(plotOutput("heatMap"))
                )
            )
        ),
        
        tabPanel("Chloe",
                 fluidPage(
                     titlePanel(
                         h1("Chloe, put stuff here", align = "center")),
                     mainPanel(h2("Hello World"))
                 )
        ),

        tabPanel("Country Net Forest Change",
            fluidPage(
                titlePanel(
                    h1("Net Forest Change", align = "center")
                ),
                sidebarPanel(
                    selectizeInput("country", "Select Country:",
                        choices = c("Bulgaria","Czech Republic",
                                    "Denmark","Poland","Sweden",
                                    "Norway", "World"),
                        selected = "World"
                    )
                         
                ),
                mainPanel(plotOutput("plot"))
            )
        ),
        
        tabPanel("Luke",
                 fluidPage(
                     titlePanel(
                         h1("Luke, put your stuff here", align = "center")),
                     mainPanel(h2("Hello World"))
                 )
        ),
        tabPanel("Key Take Aways",
                 fluidPage(
                     titlePanel(
                         h1("Like it says, Key Take Aways", align = "center")),
                     mainPanel(h2("Hello World"))
                 )
        )
        
        
    )
)

                 
      
                
    
    
    
   