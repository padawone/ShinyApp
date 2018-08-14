#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

source("utils.R")

library(shiny)
library(tidyr)
library(dplyr)
library(leaflet)


# Define server logic required to draw a histogram
shinyServer(function(input, output,session) {
        
        
        
        # Define a dropdown list based on the regions
        output$Regions <- renderUI({
                selectInput("Regions","Region",choices = c("All",Regions))
        })
        
        
        # This reactive variable lists dynamically the events that occur in the selected region and/or department
        ListMonuments <- reactive({
                selectedRegion <- input$Regions
                selectedRegion <- ifelse(is.null(selectedRegion),"All",selectedRegion)

                filterRegion = TRUE

                if (!is.null(selectedRegion) & selectedRegion !="All") {
                        filterRegion = (clean_Cant_Patrimonio$Poblacion==selectedRegion)
                }

                #print("filters")
                filter(clean_Cant_Patrimonio,filterRegion)
        })


        observe({
                myRegion <- input$Region
                if (is.null(myRegion)) myRegion <- "All"
                # Filter the monuments linked to the selected region
                if (myRegion == "All"){

                        listMonumentsRegion <- clean_Cant_Patrimonio
                }
                else{
                        listMonumentsRegion <- clean_Cant_Patrimonio %>% filter(Poblacion==myRegion)
                }
                
                # print(input$Regions)
                # print(input$Municipios)

        })
        
     
        
        hr()
        output$map <- renderLeaflet({

                # get the position for each monument
                Long <- {ListMonuments()}$Longitud
                Lat <-  {ListMonuments()}$Latitud
                Monument_Tag <- paste({ListMonuments()}$X.U.FEFF.Nombre,{ListMonuments()}$Tipo,{ListMonuments()}$Categoria,sep=";")

                my_map <- leaflet() %>% addTiles() %>%
                        addMarkers(data= {ListMonuments()},lng = Long, lat=Lat,clusterOptions = markerClusterOptions(),popup=paste(Monument_Tag,sep=" "))
                my_map
        })
        
})
