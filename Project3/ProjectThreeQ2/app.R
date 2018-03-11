#
# This is Shiny Application For DATA608 Project 3.
# 
#
# Q2 : Often you are asked whether particular States are improving their mortality rates (per cause)
# faster than, or slower than, the national average. Create a visualization that lets your clients
# see this for themselves for one cause of death at the time. Keep in mind that the national
# average should be weighted by the national population.
#
#
#

library(shiny)
library(tidyverse)
if (!require('shinythemes')) install.packages('shinythemes')
library(shinythemes)
if (!require('plotly')) install.packages('plotly')
library(plotly)

data = read.csv('https://raw.githubusercontent.com/charleyferrari/CUNY_DATA_608/master/module3/data/cleaned-cdc-mortality-1999-2010-2.csv')

# Data for Q2.

# q2data data prep. Creating a New colum National Average for the comparison for states crude rate
# Since Deaths/Population is going in 000, multiply by 10s to make it more usable.

q2data = data %>%
  group_by(ICD.Chapter, Year) %>%
  mutate(NatAvg = round((sum(Deaths) / sum(Population)) * 100000, 1)) %>%
  select(ICD.Chapter, State, Year, Crude.Rate, NatAvg)


ui <- fluidPage(
  theme = shinythemes::shinytheme("superhero"),
  titlePanel("CDC Data Explorations for Q2"),
   
   
  sidebarLayout(
    sidebarPanel(
      selectInput('selecticd', 'ICD Chapter', q2data$ICD.Chapter),
      selectInput('selectState', 'State', q2data$State),
      p("Comparison of US States Mortality Average with that of National Average for Various Diseases")
    ),
    
    
    mainPanel(
      plotlyOutput("plot2")
    )
  )
)

# Define server logic required to answer Q2.
server <- function(input, output) {
   
  q2Data1 <- reactive({
    q2data[q2data$ICD.Chapter == input$selecticd &  q2data$State == input$selectState,]
  })
  
  output$plot2 <- renderPlotly({
    t2 <- paste0("ICD Chapter: ", input$selecticd, " | State: ", input$selectState)
    plot_ly(q2Data1(), x= ~Year, y=~Crude.Rate , type = 'scatter', mode = 'lines+markers', name = 'State Crude Avg') %>%
      add_trace(y = ~NatAvg, name = 'National Avg', mode='lines+markers') %>%
      layout(title = t2,
             xaxis = list(title = 'Year'),
             yaxis = list(title = 'State Vs Nat Avg')
            )
  })

}

# Run the application 
shinyApp(ui = ui, server = server)

