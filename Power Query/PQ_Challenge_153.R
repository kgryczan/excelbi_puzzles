library(tidyverse)
library(readxl)

input = read_excel("Power Query/PQ_Challenge_153.xlsx", range = "A1:C13") %>% 
  janitor::clean_names()
test  = read_excel("Power Query/PQ_Challenge_153.xlsx", range = "E1:G5") %>%
  janitor::clean_names()

input$pilot = factor(input$pilot, levels = unique(input$pilot), ordered = TRUE)
test$pilot = factor(test$pilot, levels = unique(test$pilot), ordered = TRUE)

result = input %>%
  group_by(pilot) %>%
  mutate(prev_landing = lag(flight_end, default = NA_POSIXct_),
         flight_time = flight_end - flight_start,
         rest_time = flight_start - prev_landing) %>%
  summarise(fly_time = sum(flight_time, na.rm = TRUE),
            rest_time = sum(rest_time, na.rm = TRUE)) %>%
  mutate(fly_time = as.numeric(fly_time, units = "hours") %>% round(2),
         rest_time = as.numeric(rest_time, units = "hours") %>% round(2)) %>%
  arrange(pilot) %>%
  ungroup() %>%
  mutate(fly_time = ifelse(fly_time == 0, NA, fly_time),
         rest_time = ifelse(rest_time == 0, NA, rest_time))

identical(result, test)
# [1] TRUE
