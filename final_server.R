library(shiny)
library(ggplot2)
library(dplyr)
library(maps)
library(mapdata)
library(readr)

# Load your data
voter_table <- read.csv("city_demongraphics.csv")

county_table <- read.csv("county_demographics.csv")

server <- function(input, output, session) {
  # Description for City Voter Counts
  output$description <- renderText({
    paste("In a state election, certain counties and cities can carry a very large weight due to their great populations.", "\n",
          "This graph displays the Cities with the highest number of registered voters. This is very important information,", "\n",
          "as knowing which cities to look at can help you understand larger trends in the state political landscape.")
    
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
    paste("Within a state election, there always tends to be a disparity between voters of different genders. ", "\n",
          "This graph displays the number and concentration of voters per gender within different counties in Washington.", "\n",
          "This is important information because knowing the concentration of male/female/other voters in counties", "\n",
          "can offer to show which areas show a lack of support for genders such as ones in the 'Other' Category")
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
}
