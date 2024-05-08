library(tidyverse)
library(readxl)

input = read_excel("Excel/451 Consecutive Numbers.xlsx", range = "A1:A20")
test  = read_excel("Excel/451 Consecutive Numbers.xlsx", range = "D1:E3")

result = input %>%
  mutate(group = cumsum(Numbers - lag(Numbers, default = 0) != 0),
         pos = ifelse(Numbers > 0, "P", "N")) %>%
  summarise(count = n() %>% as.numeric(), .by = c(group, Numbers, pos)) %>%
  filter(count == max(count), .by = pos) %>%
  summarise(Number = paste(unique(Numbers), collapse = ", "), Count = unique(count), .by = pos) %>%
  arrange(desc(Count)) %>%
  select(-pos)

identical(result, test)
# [1] TRUE