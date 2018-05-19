#
# This is Shiny Application For DATA608 Final Project.
# This application contains four tabs which shows visualization
# of Gun Violence that happens across USA.
# 1. First tab shows the casualities across states.
# 2. Next show for the last 3 years how many cities are impacted.
# 3. Show Teens killed in 2018
# 4. Show kids killed in 2018
#
#
#

library(shiny)
library(tidyverse)
if (!require('shinythemes')) install.packages('shinythemes')
library(shinythemes)
if (!require('plotly')) install.packages('plotly')
library(plotly)


data2018 = read.csv('2018gunsdatacsv.csv')
data = read.csv('GunsData.csv')
data2 = read.csv('gunteensgeo.csv')
data3 = read.csv('gunkidsgeo.csv')

data2018$totalcasualty = data2018$X..Killed + data2018$X..Injured
wrapdata = aggregate(data2018$totalcasualty, by=list(Category=data2018$State), FUN=sum)
StateCodes=data.frame(
  state=as.factor(c("AK", "AL", "AR", "AZ", "CA", "CO", "CT", "DC", "DE", "FL", "GA",
                    "HI", "IA", "ID", "IL", "IN", "KS", "KY", "LA", "MA", "MD", "ME",
                    "MI", "MN", "MO", "MS",  "MT", "NC", "ND", "NE", "NH", "NJ", "NM",
                    "NV", "NY", "OH", "OK", "OR", "PA", "PR", "RI", "SC", "SD", "TN",
                    "TX", "UT", "VA", "VT", "WA", "WI", "WV", "WY")),
  full=as.factor(c("Alaska","Alabama","Arkansas","Arizona","California","Colorado",
                   "Connecticut","District of Columbia","Delaware","Florida","Georgia",
                   "Hawaii","Iowa","Idaho","Illinois","Indiana","Kansas","Kentucky",
                   "Louisiana","Massachusetts","Maryland","Maine","Michigan","Minnesota",
                   "Missouri","Mississippi","Montana","North Carolina","North Dakota",
                   "Nebraska","New Hampshire","New Jersey","New Mexico","Nevada",
                   "New York","Ohio","Oklahoma","Oregon","Pennsylvania","Puerto Rico",
                   "Rhode Island","South Carolina","South Dakota","Tennessee","Texas",
                   "Utah","Virginia","Vermont","Washington","Wisconsin",
                   "West Virginia","Wyoming"))
)

wrapdata$Codes=StateCodes$state[match(wrapdata$Category,StateCodes$full)]



ui = navbarPage(
                theme = shinythemes::shinytheme("superhero"),
                "US Gun Violence", 
                tabPanel("2018 Choropleth Casualty Map by States",plotlyOutput("plot1")),
                tabPanel("2014 - 2017 Gun Violence",plotlyOutput("plot2")),
                tabPanel("Teens Killed By Gun Violence",plotlyOutput("plot3")),
                tabPanel("Kids Killed By Gun Violence",plotlyOutput("plot4")),
                tabPanel("About",
                         fluidRow(
                           column(12,
                                  h3("Data Source"),
                                  div(HTML("<a href='http://www.gunviolencearchive.org/methodology'>The Gun Violence Archive</a>")),
                                  
                                  h3("Final Project For DATA608 Knowledge and Visual Analytics"),
                                  div(HTML("This application is built on Shiny App using Plotly(Plotly.js and Choropleth) for visualization")),
                                  
                                  h3("Source Code"),
                                  div(HTML("https://github.com/dilipganesan/DATA608_Knowledge-and-VisualAnalytics/tree/master/FinalProject")),
                                  h3("References"),
                                  div(HTML("http://rstudio.github.io/shiny/tutorial/"))
                                  ))
                                  )
                         )
  
  
  

# Define server logic required.
server <- function(input, output) {
   
  g <- list(
    scope = 'usa',
    projection = list(type = 'albers usa'),
    showland = TRUE,
    landcolor = toRGB("gray85"),
    subunitwidth = 1,
    countrywidth = 1,
    subunitcolor = toRGB("white"),
    countrycolor = toRGB("white")
  )
  
  
  # give state boundaries a white border
  l <- list(color = toRGB("white"), width = 2)
  # specify some map projection/options
  g1 <- list(
    scope = 'usa',
    projection = list(type = 'albers usa'),
    showlakes = TRUE,
    lakecolor = toRGB('white')
  )
  
  output$plot1 <- renderPlotly(plot_geo(wrapdata, locationmode = 'USA-states') %>%
                                 add_trace(
                                   z = ~wrapdata$x, text = ~paste(wrapdata$Category, " <br />", wrapdata$x,"Causualty"), 
                                   locations = ~wrapdata$Codes,
                                   color = ~wrapdata$x
                                 ) %>%
                                 colorbar(title = "2018 Gun Casualty") %>%
                                 layout(
                                   title = '2018 Gun Violence Casualties by States<br>(Hover for breakdown)',
                                   geo = g1
                                 ))
  
  
  output$plot2 <- renderPlotly(plot_geo(data, locationmode = 'USA-states', sizes = c(1, 500)) %>%
                                 add_markers(
                                   x = ~lon, y = ~lat, size = ~Killed, color = ~Injured, hoverinfo = "text",
                                   text = ~paste(data$Killed, "Killed <br />", data$Injured, " Injured")
                                 ) %>%
                                 layout(title = 'Gun Violence in USA 2014 - 2017', geo = g))
  
  output$plot3 <- renderPlotly(plot_geo(data2, locationmode = 'USA-states', sizes = c(1, 500)) %>%
                                 add_markers(
                                   x = ~lon, y = ~lat, size = ~X..Killed, color = ~X..Killed, hoverinfo = "text",
                                   text = ~paste(data2$X..Killed, "Killed <br />", data2$X..Injured, " Injured")
                                 ) %>%
                                 layout(title = 'Teens Killed in 2018', geo = g))
  
  output$plot4 <- renderPlotly(plot_geo(data3, locationmode = 'USA-states', sizes = c(1, 500)) %>%
                                 add_markers(
                                   x = ~lon, y = ~lat, size = ~X..Killed, color = ~X..Killed, hoverinfo = "text",
                                   text = ~paste(data3$X..Killed, "Killed <br />", data3$X..Injured, " Injured")
                                 ) %>%
                                 layout(title = 'Kids Killed in 2018', geo = g))

}

# Run the application 
shinyApp(ui = ui, server = server)

