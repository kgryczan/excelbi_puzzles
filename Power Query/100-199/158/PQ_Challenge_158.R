library(tidyverse)
library(readxl)

input = read_excel("Power Query/PQ_Challenge_158.xlsx", range = "A1:K5", 
                   col_names = T, .name_repair = "unique") 
test  = read_excel("Power Query/PQ_Challenge_158.xlsx", range = "A10:G17") %>%
  mutate(across(everything(), as.character))


r1 = input %>%
  pivot_longer(cols = -c(1), values_to = "value", names_to = "variable") %>%
  mutate(variable = if_else(str_starts(variable, "D"), variable, NA_character_)) %>%
  fill(variable, .direction = "down") %>%
  group_by(Dept) %>%
  nest()

headers = r1[[2]][[1]]$value

r2 = r1 %>%
  filter(Dept != "Group") %>%
  unnest(data) %>%
  mutate(headers = headers) %>%
  pivot_wider(names_from = headers, values_from = value) %>%
  filter(!is.na(`Emp ID`)) %>%
  select(Group = Dept, Dept = variable, everything()) %>%
  ungroup()

identical(r2, test)
# [1] TRUE
