library(shiny)
library(dplyr)
library(leaflet)

load('./data/nzeq.Rdata')

nzeq <<- nzeq %>% 
    mutate(longitude=if_else(longitude<0,360+longitude, longitude)) %>%
    filter(magnitude > 0) %>%
    mutate(popUpText=paste(
        as.Date(origintime,"%Y-%m-%d"),"<br/>",
        "Magnitude: ",round(magnitude,1),"<br/>",
        "Depth: ",round(depth,1), "km")
    ) %>%
    arrange(magnitude)
currentGroup <<- 0

shinyUI(
    bootstrapPage(
        tags$style(type = "text/css", "html, body {width:100%;height:100%}"),

        leafletOutput("eqPlot", width = "100%", height = "100%"),
        tags$style("
                #controls {
                  background-color: #fff;
                  opacity: 0.5;
                  padding: 10px 25px 15px 25px;
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
                      h3("New Zealand Earthquake Data (01 June 2019 - 31 May 2020)")
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
                                  animate = animationOptions(interval = 1500, loop = FALSE)
                      ),
                      HTML("<h4>Instructions</h4>
                            <span style='font-size: 75%;'><p>
                            Select a magnitude range to update the map with just those<br/>
                            events.</p><p>
                            Select a date range to update the map with only events in that <br/>
                            date range.</p><p>
                            To view an animation over time, select a narrow date range and <br/>
                            click the small triangle at the right of the date slider.</p><p>
                            For a smoother animation, it's recommended to use a short date <br/>
                            range (2 weeks for example) and a filtered magnitude (4 to 6) for<br/>
                            example). Note the slider determines the width of time displayed<br/>
                            in each frame, not the start and end dates for the animation.</p><p>
                            <a href='https://github.com/enzedonline/shiny-app-demo' target='_blank'>
                            Code available on GitHub</a></p></span>
                           ")
                      
        )
    )
)
