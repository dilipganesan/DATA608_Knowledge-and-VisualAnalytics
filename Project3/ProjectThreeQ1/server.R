#
# This is the server logic of a Q1.
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  q1Data1 <- reactive({
    q1data[q1data$ICD.Chapter == input$selecticd, ]
  })
   
  output$plot1 <- renderPlotly({
    t1 <- paste0("ICD Chapter: ", input$selecticd)
    plot_ly(q1Data1(), x= ~State, y=~Crude.Rate , type = 'bar') %>%
    layout(title = t1,
           xaxis = list(categoryarray = cat, categoryorder = "array"),
           showlegend = FALSE)
  })
  
})
