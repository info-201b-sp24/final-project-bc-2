library(shiny)
library(ggplot2)
library(dplyr)
library(maps)
library(mapdata)
library(viridis)
library(tidyr)

data <- read.csv("county demographics.csv")
colnames(data) <- trimws(colnames(data))

wa_county_map <- map_data("county", region = "washington")
data <- data %>%
  mutate(subregion = tolower(County)) %>%
  select(subregion, Female, Male, Other, Grand.Total)

shinyServer(function(input, output) {
  output$distPlot <- renderPlot({
    selected_county <- data %>% filter(subregion == input$county)
    selected_county_melted <- selected_county %>% 
      select(Female, Male, Other) %>%
      pivot_longer(cols = c(Female, Male, Other), names_to = "Gender", values_to = "Count")
    
    ggplot(selected_county_melted, aes(x = Gender, y = Count, fill = Gender)) +
      geom_bar(stat = "identity") +
      theme_minimal() +
      scale_y_continuous(labels = scales::label_number(scale = 1/1000, suffix = "K")) +
      labs(title = paste("Gender Distribution in", input$county),
           x = "Gender",
           y = "Population Count (in thousands)")
  })
  
  output$mapPlot <- renderPlot({
    selected_county <- tolower(input$county)
    wa_county_map_highlight <- wa_county_map %>%
      left_join(data, by = "subregion")
    
    ggplot(data = wa_county_map_highlight, aes(x = long, y = lat, group = group, fill = Grand.Total)) +
      geom_polygon(color = "black") +
      coord_fixed(1.3) +
      theme_minimal() +
      scale_fill_viridis_c(option = "viridis", direction = -1, name = "Total Population") +
      geom_polygon(data = filter(wa_county_map_highlight, subregion == selected_county),
                   aes(x = long, y = lat, group = group, fill = Grand.Total),
                   color = "black", size = 1) +
      labs(title = paste("Map Highlighting", input$county),
           x = "Longitude",
           y = "Latitude")
  })
})
