library(shiny)
library(shinythemes)
library(leaflet)
library(ggplot2)
library(dplyr)
library(maps)
library(mapdata)
library(viridis)

data <- read.csv("county demographics.csv")
colnames(data) <- trimws(colnames(data))

wa_county_map <- map_data("county", region = "washington")
data <- data %>% 
  mutate(subregion = tolower(County)) %>% 
  select(subregion, Female, Male, Other, Grand.Total)

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
  ),
  
  # County Demographics Tab
  tabPanel("County Demographics",
           sidebarLayout(
             sidebarPanel(
               selectInput("county", "Select a County:", 
                           choices = unique(data$subregion))
             ),
             mainPanel(
               verbatimTextOutput("bar_description"),
               plotOutput("distPlot"),
               plotOutput("mapPlot")
             )
           )
  )
)
