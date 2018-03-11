#
# Shiny App for CUNY DATA608 Project Three Q1.
#
# Q1 : As a researcher, you frequently compare mortality rates from particular causes across different States. 
# You need a visualization that will let you see (for 2010 only) the crude mortality rate, across all States, 
# from one cause (for example, Neoplasms, which are effectively cancers). 
# Create a visualization that allows you to rank States by crude mortality for each cause of death.
#

library(shiny)
if (!require("tidyverse")) install.packages('tidyverse')
library(tidyverse)
if (!require('shinythemes')) install.packages('shinythemes')
library(shinythemes)
if (!require('plotly')) install.packages('plotly')
library(plotly)

data = read.csv('https://raw.githubusercontent.com/charleyferrari/CUNY_DATA_608/master/module3/data/cleaned-cdc-mortality-1999-2010-2.csv')

# Data for Q1.

q1data = data %>%
  filter(Year == 2010) %>%
  select(State, Crude.Rate, ICD.Chapter) %>%
  arrange(Crude.Rate)

#q1data

shinyUI(fluidPage(
  theme = shinythemes::shinytheme("superhero"),
  titlePanel("CDC Data Exploration for Q1"),
  
  sidebarLayout(
    sidebarPanel(
        selectInput('selecticd', 'ICD Chapter', q1data$ICD.Chapter),
        p("Ranking of US States based on Crude Mortality Rates")
    ),
    
    mainPanel(
      plotlyOutput("plot1")
    )
  )
))
