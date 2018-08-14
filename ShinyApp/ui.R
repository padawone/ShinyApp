# load the required packages
library(shiny)
require(shinydashboard)
library(ggplot2)
library(dplyr)
library(leaflet)


#Dashboard header carrying the title of the dashboard
header <- dashboardHeader(title = "Monuments Dashboard")  

#Sidebar content of the dashboard
sidebar <- dashboardSidebar(
        sidebarMenu(
                menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
                uiOutput("Regions")
                 
        )
)



frow1 <- fluidRow(
        leafletOutput("map")
)



# combine the two fluid rows to make the body
body <- dashboardBody(
                frow1
)

#completing the ui part with dashboardPage
ui <- dashboardPage(title = 'Monuments Cantabria', header, sidebar, body, skin='blue')

