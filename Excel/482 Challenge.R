library(tidyverse)
library(readxl)
library(janitor)

path = "Excel/482 Soccer Result Grid.xlsx"

input = read_excel(path, range = "A2:C12") %>% clean_names() 
test  = read_excel(path, range = "E2:J7")

rev_input = data.frame(team_1 = input$team_2, team_2 = input$team_1, result = input$result) %>%
  mutate(result = str_replace(result, "([0-9]+)-([0-9]+)", "\\2-\\1"))

all = bind_rows(input, rev_input) %>%
  pivot_wider(names_from = team_2, values_from = result) %>%
  arrange(team_1) %>%
  select(sort(c("team_1", colnames(.)[-1]))) %>%
  select(Team = team_1, everything()) %>%
  mutate(across(everything(), ~ifelse(is.na(.), "X", .)))

identical(all, test)
# [1] TRUE