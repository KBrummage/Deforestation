# Deforestation
R project to link deforestation to global factors

### Members

Chloe Hu
Luke Robert Brown
Ken Brummage

## Project Proposal
In order to understand how factors affect deforestation rates of different countries.  We will attempt to link certain economic, health, and geospatial factors contribute to deforestation rates of countries around the glob.  

## Data and Audience
The dataset the group will be working with includes the World Bank dataset https://databank.worldbank.org/ which includes parameters regarding health, wealth, and other national factors.  We will also be working with a dataset regarding Deforestation. It is uploaded to the website Kaggle by Chiticariu Cristian. The data is provided by https://ourworldindata.org/deforestation. The dataset captures annual change in forest area in various countries throughout the world. Four key features are listed in the dataset: entity(country), country code, year, and net change in forest area.  Together we hope to find any key indicators to explain why some countries are rapidly losing forest cover while others are increasing their forest canopy. 
The target audience of our project would range from policy makers, environmentalists, scholars, to the general public who are interested in the ecological cost in economic growth. The project tries to answer the following questions:1) what is the general trend of deforestation worldwide, is the deforestation level exacerbated or is it improved over the years? 2) Which country has the highest deforestation rate and which one has the lowest deforestation rate in one particular year? 3)How much global deforestation occurs per year? 4) How is deforestation correlated with development in one or various ways?
 
## Technical Description
All of the relevant data we will be using for our analysis is in the form of .csv files and should not require an API. We won’t be using any major new libraries and should stick to mostly ggplot and dplyr, as we will be creating charts and graphs to display our findings.
We will need to merge datasets from both the World Bank and deforestation datasets so as to link relevant data (such as income per capita or economic growth) to net deforestation loss.
Statistical analysis will play a key role in our conclusions. We will use it to determine the general trend of deforestation worldwide, the amount of global deforestation each year, and countries with the highest and lowest amounts of deforestation each year. Most of this should be relatively straightforward. Where we anticipate issues arising will be in determining if deforestation is correlated with economic growth and development in any way. This will be more difficult as we are determining correlation as opposed to reporting numbers computed from the datasets.

## Project Set-up
Repository: https://github.com/KBrummage/Deforestation




