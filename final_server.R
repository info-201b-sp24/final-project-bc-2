library(shiny)
library(ggplot2)
library(dplyr)
library(maps)
library(mapdata)
library(readr)
library(viridis)


voter_table <- read.csv("city_demongraphics.csv")
county_table <- read.csv("county_demographics.csv")
data <- read.csv("county demographics.csv")
colnames(data) <- trimws(colnames(data))
wa_county_map <- map_data("county", region = "washington")
data <- data %>% 
  mutate(subregion = tolower(County)) %>% 
  select(subregion, Female, Male, Other, Grand.Total)

server <- function(input, output, session) {
  # Description for City Voter Counts
  output$description <- renderText({
    paste(" In a state election, certain counties and cities can carry a very", "\n",
          "large weight due to their great populations. This graph displays the", "\n",
          "cities with the highest number of registered voters. This is very important", "\n",
          "information as knowing which cities to look at can help you understand", "\n",
          "larger trends in the state political landscape.")
    
  })
  
  # Bar plot for City Voter Counts
  output$barPlot <- renderPlot({
    df_processed <- voter_table %>%
      filter(City != "") %>%          
      arrange(desc(Grand.Total)) %>%    
      head(input$top_values)
    
    
    # Create the bar plot
    ggplot(df_processed, aes(x = reorder(City, -Grand.Total), y = Grand.Total)) +
      geom_bar(stat = "identity", fill = "navy") +
      xlab("City") +
      ylab("Number of Registered Voters") +
      ggtitle("Number of Registered Voters by City") +
      theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) 
  })
  
  # Description for County Voter Counts Map
  output$map_description <- renderText({
    paste(" Within a state election, there always tends to be a disparity between", "\n",
          "voters of different genders. This graph displays the number and", "\n",
          "concentration of voters per gender within different counties in Washington.", "\n",
          "This is important information because knowing the concentration of", "\n",
          "male/female/other voters in counties can offer to show which areas show a", "\n",
          "lack of support for genders such as ones in the 'Other' Category")
  })
  
  # Map for County Voter Counts
  output$votesMap <- renderLeaflet({
    gender_column <- input$gender_votes
    
    # Merge voter counts with map data
    wa_county_map <- map_data("county", region = "washington")
    county_table$County <- tolower(county_table$County)
    merged_data <- left_join(county_table, wa_county_map, by = c("County" = "subregion"))
    
    leaflet(merged_data) %>%
      addTiles() %>%
      addCircleMarkers(~long, ~lat, 
                       radius = ~get(gender_column) / 50000,  # Adjust size as needed
                       popup = ~paste0(County, ": ", get(gender_column), " votes"))
  })
  
  output$bar_description <- renderText({
    paste(" Using the dropdown menu, you can select a county to view the gender", "\n",
          "distribution in that county. The bar chart displays the number of", "\n",
          "individuals in each gender category (Female, Male, Other). Additionally,", "\n",
          "the map highlights the selected county and shows the total population.", "\n",
          "This information is crucial for understanding the demographic composition", "\n",
          "of different regions and identifying trends in population distribution", "\n",
          "across the state.")
  })
  
  # Render plots and map for County Demographics Tab
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
}