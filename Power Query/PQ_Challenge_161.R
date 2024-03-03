library(tidyverse)
library(readxl)

input = read_excel("Power Query/PQ_Challenge_161.xlsx", range = "A1:C30") %>%   janitor::clean_names()
test  = read_excel("Power Query/PQ_Challenge_161.xlsx", range = "E1:H30") %>%   janitor::clean_names()

find_mode <- function(x) {
  x <- na.omit(x)
if (length(x) == 0) return(NA)
  freq <- table(x)
  modes <- as.numeric(names(freq)[freq == max(freq)])
  return(modes)
}

input2 = input %>%
  group_by(group) %>%
  mutate(group_min_week = min(week_no)) %>%
  ungroup() %>%
  mutate(week_start_date = as.Date(paste0(week_no, "1"), format = "%Y%U%u")) %>%
  mutate(WM0 = week_start_date, 
         WM1 = week_start_date - weeks(1),
         WM2 = week_start_date - weeks(2),
         WM3 = week_start_date - weeks(3),
         WM4 = week_start_date - weeks(4),
         WM5 = week_start_date - weeks(5),
         WM6 = week_start_date - weeks(6),
         WM7 = week_start_date - weeks(7)) %>%
  select(group, group_min_week,  week_no, WM0, WM1, WM2, WM3, WM4, WM5, WM6, WM7) %>%
  pivot_longer(cols = starts_with("WM"), names_to = "week_marker", values_to = "valid_week_start") %>%
  mutate(group_min_week = as.Date(paste0(group_min_week, "1"), format = "%Y%U%u")) %>%
  left_join(input %>%
              mutate(week_start_date = as.Date(paste0(week_no, "1"), format = "%Y%U%u")) , 
            by = c("group", "valid_week_start" = "week_start_date")) %>%
  filter(valid_week_start >= group_min_week) %>%
  group_by(group, week_no.x) %>%
  mutate(no_groups = n()) %>%
  ungroup() %>%
  group_by(group, week_no.x, no_groups) %>%
  summarise(winning_nos = list(winning_no), .groups = 'drop') %>%
  ungroup() %>%
  arrange(group, desc(week_no.x)) %>%
  mutate(winning_nos_ = winning_nos) %>%
  mutate(winning_nos = map(winning_nos, ~na.omit(.x))) 
  
input3 = input2 %>%
  mutate(mode = map(winning_nos, find_mode)) %>%
  mutate(mode = map_chr(mode, ~paste(., collapse = ", "))) %>%
  mutate(mode = if_else(no_groups < 8, NA, mode))

input4 = input %>%
  left_join(input3, by = c("group", "week_no" = "week_no.x")) %>%
  left_join(test, by = c("group", "week_no" = "week_no")) %>%
  select(1,2,7,9) %>%
  mutate(check = mode == max_occurred_no)
