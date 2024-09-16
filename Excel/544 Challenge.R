library(tidyverse)
library(readxl)

path = "Excel/544 Sum of First and Last Numbers.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B2")

result = input %>%
  mutate(numbers = map(Strings, str_extract_all, "\\d+")) %>%
  unnest(numbers) %>%
  unnest(numbers) %>%
  mutate(rn = row_number(), 
         min = min(rn),
         max = max(rn),
         .by = Strings) %>%
  filter(rn == min | rn == max) %>%
  summarise(sum = sum(as.numeric(numbers)))

identical(result$sum, test$`Answer Expected`)
# [1] TRUE