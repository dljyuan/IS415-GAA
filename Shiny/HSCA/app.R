library(shiny)
library(tmap)
library(dplyr)
library(shinythemes)
library(leaflet)

# Define UI for application that draws a histogram
ui <- fluidPage(
    theme = shinytheme("superhero"),

    titlePanel("LISA Map"),
    sidebarLayout(
      sidebarPanel(
        sliderInput("threshold", "Significant Level:", min = 0, max = 0.5, value = 0.05, step = 0.01),
        selectInput("fill_var", "Bin Type:", choices = c("Blue Bins", "E-Waste Bins", "Incentive Bins"), selected = "Blue Bins")
      ),
      mainPanel(
        tmapOutput("lisa_map")
      )
    )
)

# Define server logic
server <- function(input, output) {
  
  # Load data initially based on the default variable
  lisa_data <- reactiveVal(NULL)
  
  observe({
    if (input$fill_var == "Blue Bins") {
      lisa_data(readRDS("lisa_blue.rds"))
    } else if (input$fill_var == "E-Waste Bins") {
      lisa_data(readRDS("lisa_ew.rds"))
    } else if (input$fill_var == "Incentive Bins") {
      lisa_data(readRDS("lisa_in.rds"))
    }
  })
  
  # Filter data based on threshold value
  lisa_sig <- reactive({
    req(lisa_data()) # Ensure data is available before filtering
    data <- lisa_data()  # Get the current value of lisa_data
    filter(data, p_ii < input$threshold)  # Filter data based on the condition
  })
  
  # Render map
  output$lisa_map <- renderTmap({
    tmap_mode("plot")
    tm_basemap("OpenStreetMap") + 
    tm_shape(lisa_data()) +
      tm_polygons() +
      tm_borders(alpha = 0.2) +
      tm_shape(lisa_sig()) +
      tm_fill("mean") +  
      tm_borders(alpha = 0.4)
  })
}

# Run the application
shinyApp(ui = ui, server = server)
