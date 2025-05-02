library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_222.xlsx"
input = read_excel(path, range = "A1:I7")
test  = read_excel(path, range = "A11:D17")

result = input %>%
  pivot_longer(cols = -c(1), names_to = c(".value", "Type"), names_pattern = "(\\D+)(\\d+)") %>%
  mutate(rank = rank(desc(Marks), ties.method = "first"), .by = Test) %>%
  select(-Type) %>%
  unite("TM", Student, Marks, sep = " ") %>%
  pivot_wider(names_from = rank, values_from = TM, names_prefix = "Student")  %>%
  select(Subjects = Test, sort(names(.)[-1])) %>%
  filter(!is.na(Subjects)) %>%
  mutate(across(2:ncol(.), ~ifelse(as.numeric(str_extract(., "\\d+")) >= 40, str_remove(., "\\s\\d+"), NA_character_))) %>%
  select(where(~!all(is.na(.)))) %>%
  arrange(Subjects) 

identical(result, test)
#> [1] TRUE         