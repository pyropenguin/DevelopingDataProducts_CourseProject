#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Weather Data by Airport"),
  h4('Jonathan Kunze'),
  p('March 26, 2017'),
  
  # Sidebar with a dropdown input
  sidebarLayout(
    sidebarPanel(
      airports <- c("KCLT","KCQT","KHOU","KIND","KJAX",
                    "KMDW","KNYC","KPHL","KPHX","KSEA"),
      selectInput('airport', "Select Airport", airports),
      p('US weather history data from:'),
      a(href="https://github.com/fivethirtyeight/data/tree/master/us-weather-history", "FiveThirtyEight"),
      p('')
    ),
    
    # Show a plot of the temperature data
    mainPanel(
      plotOutput("tempPlot")
    )
  ),
    
  # Describe the usage
  mainPanel(
    h3('Usage'),
    p('Select an airport from the dropdown above to see weather history
       for that location.'),
    p('The daily difference between high and record high temperature
       is shown in vertical red bars.'),
    p('The daily difference between low and record low temperature 
       is shown in vertical blue bars.'),
    p('Daily mean temperature is represented by a black line.')
  )
))
