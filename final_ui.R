library(shiny)
library(shinythemes)
library(leaflet)

# Define UI
ui <- navbarPage(
  theme = shinytheme("superhero"),
  "Largest City Voter Counts in Washington State",
  
  # Largest City Voter Counts Tab
  tabPanel("City Voter Counts",
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
  ),
  
  # County Voter Counts Map Tab
  tabPanel("County Voter Counts Map",
           sidebarLayout(
             sidebarPanel(
               selectInput("gender_votes", "Select the gender category to display votes:",
                           choices = list("Male" = "Male", "Female" = "Female", "Other" = "Unknown.Other"))
             ),
             mainPanel(
               verbatimTextOutput("map_description"),
               leafletOutput("votesMap")
             )
           )
  )
)