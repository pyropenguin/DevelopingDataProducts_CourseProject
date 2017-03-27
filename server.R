#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(data.table)

wx_path <- './us-weather-history/'
files <- list.files(wx_path, '*.csv')

wx <- data.table()
for (file in files)
{
  # Consolidate all wx data, add airport code
  wx <- rbind(wx, fread(paste0(wx_path,file))[,airport:=gsub('.csv','',file)])
}

# Data Formatting
wx$date <- as.POSIXct(wx$date)

# Consolidate Airport List
airports <- gsub('.csv','',files)

# Define server logic required to draw the temperature data plots
shinyServer(function(input, output) {
   
  output$tempPlot <- renderPlot({
    
    # Use the airport dropdown input to subset the data and compute the graph
    wx_sub <- wx[airport==input$airport]
    
    g <- ggplot(wx_sub, aes(x=date))
    g <- g + geom_line(aes(y=actual_mean_temp))
    g <- g + geom_point(aes(y=record_min_temp), color='blue', size=1)
    g <- g + geom_point(aes(y=record_max_temp), color='red', size=1)
    g <- g + geom_point(aes(y=actual_min_temp), color='blue', size=1, alpha=0.1)
    g <- g + geom_point(aes(y=actual_max_temp), color='red', size=1, alpha=0.1)
    g <- g + geom_segment(aes(y=actual_min_temp, yend=record_min_temp, 
                              x=date, xend=date, 
                              color=ifelse(actual_min_temp > record_min_temp,'Record Low','Normal')))
    g <- g + geom_segment(aes(y=actual_max_temp, yend=record_max_temp, 
                              x=date, xend=date,
                              color=ifelse(actual_max_temp < record_max_temp,'Record High','Normal')))
    g <- g + scale_colour_manual(values = setNames(c('blue','grey','red'),c('Record Low','Normal','Record High')))
    g <- g + labs(title=paste('Mean, Max and Min Temperatures for', input$airport),
                  x='Date', y='Temperature (°F)')
    g <- g + theme(legend.position="none")
    return(g)
    
  })
  
})
