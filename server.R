library(shiny)
library(rsconnect)
library(ggplot2)
library(dplyr)

voter_table <- read.csv("city_demongraphics.csv")

server <- function(input, output) {
  output$description <- renderText({
    paste(" In a state election, certain counties and cities can carry a very large weight due to their great populations.", "\n",
          "This graph displays the Cities with the highest number of registered voters. This is very important information,", "\n",
          "as knowing which cities to look at can help you understand larger trends in the state political landscape.")
          
  })
  
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
}
