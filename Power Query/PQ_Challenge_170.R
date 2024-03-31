library(tidyverse)
library(readxl)

input = read_excel("Power Query/PQ_Challenge_170.xlsx", range = "A1:C92")
test  = read_excel("Power Query/PQ_Challenge_170.xlsx", range = "E1:H3")

result = input %>%
  mutate(week_part = ifelse(wday(Date) %in% c(1, 7), "Weekend", "Weekday")) %>%
  summarise(total = sum(Sale), 
            .by = c(week_part, Item)) %>%
  mutate(min = min(total),
         max = max(total),
         full_total = sum(total),
         .by = c(week_part)) %>%
  filter(total == min | total == max) %>%
  mutate(min_max = ifelse(total == min, "min", "max")) %>%
  select(-c(total, min, max)) %>%
  pivot_wider(names_from = min_max, values_from = Item, values_fn = list(Item = list)) %>%
  mutate(min = map_chr(min, ~paste(.x, collapse = ", ")),
         max = map_chr(max, ~paste(.x, collapse = ", "))) 

colnames(result) <- colnames(test)

identical(result, test)
# [1] TRUE
