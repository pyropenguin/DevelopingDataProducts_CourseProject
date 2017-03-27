# Developing Data Products Course Project Sandbox
library(ggplot2)
library(data.table)
setwd('~/Dropbox/Data Science Specialization/Developing Data Products/DevelopingDataProducts_CourseProject/')

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

# Chooser Input
airports <- gsub('.csv','',files)
sel.airport <- airports[9]

g <- ggplot(wx[airport==sel.airport], aes(x=date))
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
g <- g + labs(title=paste('Mean, Max and Min Temperatures for', sel.airport),
              x='Date', y='Temperature (°F)')
g <- g + theme(legend.position="none")
g

save(wx, file='WeatherData.Rda')
