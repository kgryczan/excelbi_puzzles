library(tidyverse)
library(readxl)

path = "Excel/017 All vowels.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B5")

vowels = c("a", "e", "i", "o", "u")

result = input %>% 
  mutate(words = str_to_lower(Words)) %>%
  mutate(has_all = map_lgl(words, ~all(str_detect(.x, vowels)))) %>%
  filter(has_all) %>%
  select(Words)

identical(result$Words, test$`Answer Expected`)
#> [1] TRUE