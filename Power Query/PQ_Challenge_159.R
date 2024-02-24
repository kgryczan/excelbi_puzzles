library(tidyverse)
library(readxl)

input = read_excel("Power Query/PQ_Challenge_159.xlsx", range = "A1:D19")
test  = read_excel("Power Query/PQ_Challenge_159.xlsx", range = "F1:I73")

calendar = input %>%
  select(-c(Sales,Month)) %>%
  group_by(Name) %>%
  expand_grid(Y = unique(Year), M = 1:12) %>%
  distinct() %>%
  filter(Y == Year) %>%
  select(Name, Year, Month = M) %>%
  ungroup()

result = calendar %>%
  left_join(input, by = c("Name", "Year", "Month")) %>%
  replace_na(list(Sales = 100))

identical(result, test)
# [1] TRUE
