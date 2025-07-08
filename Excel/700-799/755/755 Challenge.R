library(tidyverse)
library(readxl)

path = "Excel/700-799/755/755 Character more than once in a string.xlsx"
input = read_excel(path, range = "A2:A10")
test  = read_excel(path, range = "C2:G5")

result = input %>%
  mutate(char = str_split(str_to_lower(Cities), "")) %>%
  unnest(char) %>%
  mutate(rep_char = n(), .by = c(Cities, char)) %>%
  filter(rep_char > 1) %>%
  unique() %>%
  arrange(char, Cities) %>%
  select(-rep_char) %>%
  mutate(rn = row_number(), .by = char) %>%
  pivot_wider(names_from = char, values_from = Cities) %>%
  select(-rn)

all.equal(result, test)
# > TRUE