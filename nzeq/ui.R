library(shiny)
library(dplyr)
library(leaflet)

load('./data/nzeq.Rdata')

nzeq <<- nzeq %>% 
    mutate(longitude=if_else(longitude<0,360+longitude, longitude)) %>%
    filter(magnitude > 0) %>%
    arrange(magnitude)

shinyUI(
    bootstrapPage(
        tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
        leafletOutput("eqPlot", width = "100%", height = "100%"),
        
        tags$style("
                #controls {
                  background-color: #fff;
                  opacity: 0.5;
                  padding: 10px 25px 20px 25px;
                }
                #controls:hover{
                  opacity: 0.8;
                }
                #title {
                  background-color: #ffffff0;
                  opacity: 0.9;
                  padding: 0px 10px 0px 15px;
                }
       "),
        absolutePanel(top=10, left=30, id = "title", class = "panel panel-default",
                      h3("New Zealand Earthquake Data (01 Jan 2019 - 31 May 2020)")
                      ),
        
        absolutePanel(top=80, left=30, id = "controls", class = "panel panel-default",
                      h4("Select Filters"),
                      sliderInput("magnitude",
                                  "Magnitude:",
                                  min = 0,
                                  max = 6,
                                  value = c(0,6),
                                  step = 0.2),
                      sliderInput("date",
                                  "Date:",
                                  min = as.Date("2019-06-01","%Y-%m-%d"),
                                  max = as.Date("2020-06-01","%Y-%m-%d"),
                                  value=as.Date(c("2019-06-01", "2020-06-01")),
                                  step=7,
                                  timeFormat="%Y-%m-%d",
                                  animate = animationOptions(interval = 2000, loop = FALSE)
                      ),
                      HTML("<h4>Instructions</h4><small><p>
                            Select a magnitude range to update the map with <br/>
                            just those events.</p><p>
                            Select a date range to update the map with only <br/>
                            events in that date range.</p><p>
                            To view an animation over time, select a narrow date<br/>
                            range and click the small triangle at the right of<br/>
                            the date slider.</p><p>
                            For a smoother animation, it's recommended to use a<br/>
                            short date range (3 weeks for example) and a filtered<br/>
                            magnitude (3 to 6 for example).</p><p>
                            <a href='https://github.com/enzedonline/shiny-app-demo' target='_blank'>
                            Code available on GitHub</a></p></small>
                           ")
                      
        )
    )
)
