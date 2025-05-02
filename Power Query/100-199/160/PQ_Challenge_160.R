library(tidyverse)
library(readxl)

input = read_excel("Power Query/PQ_Challenge_160.xlsx", range = "A1:C8")
test  = read_excel("Power Query/PQ_Challenge_160.xlsx", range = "F1:M8")

grid = crossing(city1 = input$Cities, city2 = input$Cities) %>%
  mutate(x1 = input$x[match(city1, input$Cities)],
         y1 = input$y[match(city1, input$Cities)],
         x2 = input$x[match(city2, input$Cities)],
         y2 = input$y[match(city2, input$Cities)], 
         dist = round(sqrt((x2 - x1)^2 + (y2 - y1)^2),2)) %>%
  select(Cities = city1, city2, dist) %>%
  pivot_wider(names_from = city2, values_from = dist)

identical(test, grid)
# [1] TRUE
