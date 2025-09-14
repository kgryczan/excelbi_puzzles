library(tidyverse)
library(readxl)
Sys.setlocale("LC_TIME", "C")

path = "Power Query/300-399/322/PQ_Challenge_322.xlsx"
input = read_excel(path, range = "A1:C20")
test  = read_excel(path, range = "E1:J12")

result = input %>%
  rowwise() %>%
  mutate(date = list(seq(`From Date`, `To Date`, by = "day"))) %>%
  unnest(date) %>%
  separate_longer_delim(Employees, delim = ", ") %>%
  ungroup() %>%
  filter(year(date) == 2024) %>%
  select(date, Employees) %>% 
  mutate(Month = month(date, label = TRUE, abbr = FALSE),
         Month = factor(Month, levels = month.name, ordered = TRUE),
         is_weekend = if_else(wday(date) %in% c(1, 7), "Weekend", "Weekday")) %>%
  filter(is_weekend == "Weekday") %>%
  count(Month, Employees, name = "Count") %>%
  complete(Month, Employees, fill = list(Count = 0))  %>%
  pivot_wider(names_from = Employees, values_from = Count, values_fill = 0) %>%
  filter(Month != "October") %>%
  mutate(Month = as.character(Month)) 

all.equal(result, test, check.attributes = FALSE)
# TRUE