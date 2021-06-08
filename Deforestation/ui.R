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
                            tags$h2("Global Deforestation Rates and Indicators", align="center"),
                            tags$p(tags$b("Deforestation"), "is the permanent removal of trees to make room for something besides forest."),
                            tags$p("Net deforestation is the amount of deforested land subtracted from the amound of land reclaimed by the forests."),
                            tags$p("This can include clearing the land for agriculture or grazing, or using the timber for fuel, construction or manufacturing."),
                            tags$p("This app was created to showcase the different rates of deforstation globally with respect to net loss and as a percent of a country's total square area."),
                            tags$h4("Top causes of deforestation"),
                            tags$ul(
                                tags$li("agriculture"),
                                tags$li("unsustainable forest management"),
                                tags$li("mining"),
                                tags$li("infrastructure projects"),
                                tags$li("increased fire incidence and intensity")
                            )
                        ),
                        mainPanel(
                          plotOutput("mainMap"),
                          tags$p("Datasets for regarding Deforestation was obtained from ",tags$a(href = "	https://fra-data.fao.org/WO/assessment/fra2020", "this site.")),
                          tags$p("Datasets of key global indicators to compare against deforestation rates can be found", tags$a(href="https://data.worldbank.org/", "at the World's Bank data site.")),
                          tags$p("This project was created by Chloe Hu, Luke Robert Brown, and Ken Brummage")
                          )
                    )
            )
        ),
        
        tabPanel("Key Global Indicators",
                 fluidPage(
                   titlePanel(
                     h1("Largest Indicators of Deforestation Globally", align = "center")),
                   
                   sidebarPanel(
                     h2("Moderate correlation between specific global indicators and deforestation"),
                     radioButtons("keyIndicators", label = h3("key global indicators"),
                                  choices = list("CO2 Emissions" = "CO2Emissions",
                                                 "Cereal Production" = "cereal",
                                                 "Methane Emissions" = "methaneEmissions",
                                                 "Gross Capital Formation (% of GDP)" = "gCF",
                                                 "Forest area (% of land area)" = "forestArea",
                                                 "Livestock production index" = "lPI", 
                                                 "Agricultural land (% of land area)" = "aPL",
                                                 "Crop Production Index" = "cPI",
                                                 "Agriculture, forestry, and fishing, value added (% of GDP)" = "aFF" 
                                                 
                                  ), 
                                  selected = "CO2Emissions"),
                     radioButtons("netPercent", label = h3("annual net or percent difference"),
                                  choices = list("Annual Net Change of Forest Cover" = "netForestChange",
                                                 "Annual Percentage Change of Forest Cover" = "percentChange" 
                                  ), 
                                  selected = "netForestChange")
                     
                   ),
                   mainPanel(plotOutput(outputId = "indicatorPlot"),
                             tags$p(textOutput("value"))
                   )
                   
                 )
                 
        ),
        
        tabPanel("Major Contributors to Deforestation",
            fluidPage(
                h1("Global Deforestation Rates", align="center"),
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
                    mainPanel(plotOutput(outputId ="heatMap", height = 350),
                              plotOutput(outputId = "heatChart", height = 350))
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
                        choices = c("Aruba","Argentina","Austria","Azerbaijan","Burundi","Belgium","Bangladesh","Bulgaria","Bahrain","Belarus","Belize","Bolivia","Brazil","Bhutan","Central African Republic","Canada","Switzerland","Chile","China","Cameroon","Colombia","Costa Rica","Cuba","Cayman Islands","Germany","Djibouti","Denmark","Algeria","Ecuador","Spain","Estonia","Ethiopia","Faroe Islands","Gabon","Georgia","Gibraltar","Equatorial Guinea","Greenland","Guatemala","Guyana","Honduras","Croatia","Hungary","Indonesia","Isle of Man","India","Ireland","Iraq","Iceland","Jamaica","Kuwait","Liberia","Liechtenstein","Lithuania","Latvia","Morocco","Monaco","Moldova","Maldives","Mexico","Mali","Myanmar","Montenegro","Mongolia","Mozambique","Mauritania","Mauritius","Malawi","Niger","Nigeria","Nicaragua","Netherlands","Norway","Nepal","Nauru","New Zealand","Panama","Peru","Papua New Guinea","Poland","Paraguay","Qatar","Romania","Sudan","Senegal","Singapore","El Salvador","San Marino","Somalia","Serbia","Sao Tome and Principe","Suriname","Slovenia","Sweden","Togo","Thailand","Tunisia","Turkey","Tanzania","Uganda","Ukraine","Uzbekistan","Vietnam","South Africa","Zambia","Zimbabwe","World"),
                        selected = "World"
                    ),
                    
                         
                ),
                mainPanel(plotOutput("plot1"))
            )
        ),

        tabPanel("Key Take Aways",
                 fluidPage(
                     titlePanel(
                         h1("Key Take Aways", align = "center")),
                     mainPanel(
                       tags$ul(
                        tags$li(tags$h4("There is a moderate correlation between agriculture industries"),
                                  tags$p("The most notable insight we had was when analyzing the CO2 emissions indicator variable. We found that there was a low, positive correlation between CO2 Emissions and net forest change (in hectares). We obtained a R-value of 0.2, which is a significant R-value for a low correlation.  This is saying that, generally, as a country has higher amounts of CO2 emissions, they are losing less forest area each year. This, intuitively, doesn’t make sense as we would expect countries with high C02 emissions to lose the most forest each year. Further research led us to find that CO2 emissions from deforestation account for roughly 20% of global CO2 emissions, pointing towards the negative trend we did not find.")
                                 ),
                        tags$li(tags$h4("Finding key indicators that can predict deforestation is not as simple as perceived."),
                                tags$p("Most of our data was taken from the indicators page from the world bank. We think this data is probably some of the higher quality data available for the indicators we analyzed. I expect completely unbiased results.")
                                ),
                         tags$li(tags$h4("With a total of 127 billion hectares globally, and only 74 billion reported on average for each period, roughly 42% of global data is missing."),
                                 tags$p("There were some non-inconsequential gaps in the data for some years, mainly in less developed countries which could have skewed our results. We do not see issues with the data potentially harming anyone.  Advancing this project may very well come down to having data for every country for certain indicators.")
                                 ),
                         tags$li(tags$h4("Changes due to complex global economies are hard to decipher"),
                                 tags$p("Due to the seemingly enless causes of deforestation, coupled with the fickle natural global recovery of forests, it is exceedingly difficult to locate the key indicators for a country's cause of deforestation - if one even exists.")
                         )
                       ),
                       tags$a(href="https://github.com/KBrummage/Deforestation", "Take a look at our repo." )
                       )
                     )
                 
        )
        
    )
)

                 
      
                
    
    
    
   