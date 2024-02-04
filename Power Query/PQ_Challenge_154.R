library(tidyverse)
library(readxl)

input = read_excel("Power Query/PQ_Challenge_154.xlsx", range = "A1:C10") %>% 
  janitor::clean_names()
test  = read_excel("Power Query/PQ_Challenge_154.xlsx", range = "E1:I23") %>%
  janitor::clean_names()

input$pilot = factor(input$pilot, levels = unique(input$pilot), ordered = TRUE)
test$pilot = factor(test$pilot, levels = unique(test$pilot), ordered = TRUE)

fly = input 
rest = input %>%
  group_by(pilot) %>%
  mutate(prev_end = lag(flight_end, default = NA_POSIXct_)) %>%
  ungroup() %>%
  select(pilot, rest_start = prev_end, rest_end = flight_start) %>%
  na.omit()

get_months = function(start, end) {
  seq = seq(floor_date(start, "month"), ceiling_date(end, "month"), by = "month")
  seq[1] <- start
  seq[length(seq)] <- end
  df = tibble(start = seq[1:(length(seq)-1)], end = seq[2:length(seq)])
  return(df)
}

a = fly %>%
  mutate(df = map2(flight_start, flight_end, get_months)) %>%
  unnest(df) %>%
  select(pilot, start, end) %>%
  mutate(mode = "fly")
b = rest %>%
  mutate(df = map2(rest_start, rest_end, get_months)) %>%
  unnest(df) %>%
  select(pilot, start, end) %>%
  mutate(mode = "rest")

result = bind_rows(a, b) %>%
  mutate(month = month(start),
         year = year(start),
         duration = difftime(end, start, "hours")) %>%
  group_by(pilot, mode, month, year) %>%
  summarise(duration = sum(duration, na.rm = TRUE) %>% as.numeric() %>% round(2)) %>%
  ungroup() %>%
  pivot_wider(names_from = mode, values_from = duration, 
              values_fill = list(duration = 0), names_glue = "{mode}_time") %>%
  left_join(test, by = c("pilot","year", "month"), suffix = c("", "_test")) %>%
  mutate(check_fly = fly_time == fly_time_test,
         check_rest = rest_time == rest_time_test)

              