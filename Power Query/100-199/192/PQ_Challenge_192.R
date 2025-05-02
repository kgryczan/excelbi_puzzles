library(tidyverse)
library(readxl)

path = 'Power Query/PQ_Challenge_192.xlsx'
input = read_excel(path, range = "A1:E14")
test  = read_excel(path, range = "G1:J6")

count_workdays <- function(from, to) {
  map2(from, to, seq, by = "days") %>% 
    map(~ tibble(timeperiod = .x)) %>%
    map(~ mutate(.x, weekday = wday(timeperiod, week_start = 1)))  %>%
    map(~ filter(.x, weekday %in% 1:5)) %>%
    map_int(~ nrow(.x))
}

result = input %>%
  filter_all(any_vars(!is.na(.))) %>%
  fill(everything(), .direction = "down") %>%
  rename("scenario" = 3) %>%
  pivot_wider(names_from = scenario, values_from = c(4, 5)) %>%
  mutate(`Schedule Performance` = case_when(
    `To Date_Actual` > `To Date_Plan` ~ "Overrun",
    `To Date_Actual` < `To Date_Plan` ~ "Underrun",
    TRUE ~ "On Time"
  ),
  `Actual Dates` = map2_int(`From Date_Actual`, `To Date_Actual`, count_workdays) ,
  `Plan Dates` = map2_int(`From Date_Plan`, `To Date_Plan`, count_workdays),
  `Cost Performance` = case_when(
    `Actual Dates` > `Plan Dates` ~ "Overrun",
    `Actual Dates` < `Plan Dates` ~ "Underrun",
    TRUE ~ "At Cost"
  )) %>%
  mutate(nr = row_number(), .by = Project) %>%
  select(Project, Phase, nr, `Schedule Performance`, `Cost Performance`) %>%
  mutate(Project = if_else(nr == 1, Project, NA_character_)) %>%
  select(-nr)

identical(result, test)
# [1] TRUE
