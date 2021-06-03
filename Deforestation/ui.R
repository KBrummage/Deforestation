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
                    sidebarLayout(
                        sidebarPanel(
                            tags$h2("Global Deforestation Rates", align="center"),
                            tags$p(tags$b("Deforestation"), "is the permanent removal of trees to make room for something besides forest."),
                            tags$p("This can include clearing the land for agriculture or grazing, or using the timber for fuel, construction or manufacturing."),
                            tags$hr(),
                            tags$h4("Top causes of deforestation"),
                            tags$ul(
                                tags$li("agriculture"),
                                tags$li("unsustainable forest management"),
                                tags$li("mining"),
                                tags$li("infrastructure projects"),
                                tags$li("increased fire incidence and intensity")
                            )
                        ),
                        mainPanel(plotOutput("mainMap"))
                    )
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
        
        tabPanel("Major Contributors to Deforestation",
                 fluidPage(
                     titlePanel(
                         h1("Top 5 Largest Contributors to Global Deforestation", align = "center")),
                     sidebarLayout(
                        sidebarPanel(
                         h2("sideBarPanel")
                         
                        ),
                        mainPanel(h2("mainPanel"))
                     )
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
        
        tabPanel("Key Global Indicators",
                 fluidPage(
                     titlePanel(
                         h1("Largest Indicators of Deforestation Nationally", align = "center")),
                     
                         sidebarPanel(
                             h2("Two Trendline charts showing moderate correlation between"),
                             tags$ol(
                               tags$li("Percentage of GDP in the agriculture/forestry/fishing industry"),
                               tags$li("Percentage of GDP in Gross Capital Formation")
                             )
                             
                         ),
                         mainPanel(plotOutput("affPlot"),
                                   tags$hr(),
                                   plotOutput("gcfPlot")
                        )
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

                 
      
                
    
    
    
   