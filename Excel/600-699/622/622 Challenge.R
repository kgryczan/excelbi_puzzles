library(tidyverse)
library(readxl)

path = "Excel/622 At least 3 different vowels.xlsx"
input = read_excel(path, range = "A2:D16")
test  = read_excel(path, range = "F2:I7")

result = input %>%
  pivot_longer(everything(), names_to = "list", values_to = "word") %>%
  filter(map_int(str_extract_all(str_to_lower(word), "[aeiou]"), ~length(unique(.x))) >= 3) %>%
  mutate(rn = row_number(), .by = list) %>%
  pivot_wider(names_from = list, values_from = word) %>%
  select(List1, List2, List3, List4)

all.equal(result, test)
#> [1] TRUE