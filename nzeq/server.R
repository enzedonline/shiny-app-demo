library(shiny)
library(leaflet)

shinyServer(function(input, output) {
    
    filteredData <- reactive({
        nzeq %>%
            filter(magnitude >= input$magnitude[1] & magnitude <= input$magnitude[2]) %>%
            filter(origintime >= input$date[1] &  origintime <= input$date[2]) %>%
            arrange(magnitude)
    })
    
    palMap <- reactive({
        colorNumeric(
            palette = "RdYlGn",
            domain = nzeq$magnitude, 
            reverse = TRUE)
    })
    
    output$eqPlot <- renderLeaflet({
        
        nzeq %>% 
            leaflet(options=leafletOptions(minZoom = 5)) %>%
            addTiles() %>%
            fitBounds(
                ~min(longitude), 
                ~min(latitude), 
                ~max(longitude), 
                ~max(latitude)
            ) %>%
            addLegend("bottomright", pal = palMap(), values = ~nzeq$magnitude,
                      title = "Magnitude",
                      opacity = 1
            )
        })
    
    observe({
        pal <- palMap()
        
        filtered <- filteredData()
        
        map <- leafletProxy("eqPlot", data = filtered)

        if (nrow(filtered)>0){
            newGroup <- currentGroup + 1
            map %>%
                addCircleMarkers(group = as.character(newGroup),
                                 radius = ~((magnitude/2)^2), 
                                 color = ~pal(magnitude), 
                                 fillColor = ~pal(magnitude), 
                                 fillOpacity = 0.6,
                                 fill = T, 
                                 stroke = F,
                                 popup = ~(popUpText)
                )
            if (currentGroup!=0) {map %>% clearGroup(as.character(currentGroup))}
            currentGroup <<- newGroup
        }
    })
})
