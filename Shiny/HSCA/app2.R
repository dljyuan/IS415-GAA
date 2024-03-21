library(shiny)
library(leaflet)

# Sample data for map markers
data <- data.frame(
  lat = c(40.7128, 34.0522),
  lng = c(-74.0060, -118.2437),
  label = c("New York City", "Los Angeles")
)

ui <- navbarPage(
  title = "Nested Tabs with Navbar",
  
  tabPanel("Tab 1",
           tabsetPanel(
             tabPanel("Subtab 1.1",
                      h2("This is Subtab 1.1"),
                      p("This is some content for Subtab 1.1.")
             ),
             tabPanel("Subtab 1.2",
                      h2("This is Subtab 1.2"),
                      p("This is some content for Subtab 1.2.")
             )
           )
  ),
  
  tabPanel("Tab 2",
           h2("This is Tab 2"),
           p("This is some content for Tab 2.")
  )
)

server <- function(input, output) {
  output$map1 <- renderLeaflet({
    leaflet(data = data) %>%
      addTiles() %>%
      addMarkers(~lng, ~lat, popup = ~label)
  })
  
  output$map2 <- renderLeaflet({
    leaflet(data = data) %>%
      addTiles() %>%
      addMarkers(~lng, ~lat, popup = ~label)
  })
}

shinyApp(ui = ui, server = server)
