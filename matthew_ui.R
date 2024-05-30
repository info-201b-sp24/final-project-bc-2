library(shiny)
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

shinyUI(fluidPage(
  titlePanel("County Demographics"),
  sidebarLayout(
    sidebarPanel(
      selectInput("county", "Select a County:", 
                  choices = unique(data$subregion))
    ),
    mainPanel(
      plotOutput("distPlot"),
      plotOutput("mapPlot")
    )
  )
))
