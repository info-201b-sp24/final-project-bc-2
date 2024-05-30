ui <- fluidPage(
  titlePanel("Largest City Voter Counts in Washington State"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("top_values", "Select the number of cities to display:",
                  min = 2, max = 50, value = 10)
    ),
    mainPanel(
      verbatimTextOutput("description"),
      plotOutput("barPlot")
    )
  )
)
