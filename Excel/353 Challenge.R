library(tidyverse)
library(readxl)

input = read_excel("Excel/353 Missing Letters.xlsx", range = "A1:A10")
test  = read_excel("Excel/353 Missing Letters.xlsx", range = "B1:B10")

result = input %>%
  mutate(let = strsplit(Letters, ", ")) %>%
  mutate(let = map(let, sort)) %>%
  mutate(min = map(let, min),
         max = map(let, max),
         min_index = map_int(min, ~ which(letters == .x)),
         max_index = map_int(max, ~ which(letters == .x)), 
         seq = map2(min_index, max_index, ~ letters[.x:.y]),
         diff = map2(seq, let, ~ setdiff(.x, .y)),
         answer = map_chr(diff, ~ paste(.x, collapse = ", "))
         ) %>%
  select(Letters, answer) %>%
  mutate(answer = ifelse(answer == "", NA, answer))

identical(result$answer, test$`Expected Answer`)
# [1] TRUE


