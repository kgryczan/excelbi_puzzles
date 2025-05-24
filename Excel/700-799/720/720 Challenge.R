library(tidyverse)
library(readxl)
library(stringi)

path = "Excel/700-799/720/720 Transpose if minimum 2 different vowels.xlsx"
input = read_excel(path, range = "A2:B16")
test = read_excel(path, range = "D2:I5")

result = input %>%
  mutate(Rivers = stri_trans_general(Rivers, "Latin-ASCII")) %>%
  rowwise() %>%
  mutate(
    Rivers_vows = list(unique(unlist(str_extract_all(
      str_to_lower(Rivers),
      "[aeiou]"
    ))))
  ) %>%
  filter(length(Rivers_vows) >= 2) %>%
  ungroup() %>%
  select(-Rivers_vows) %>%
  arrange(Group, Rivers) %>%
  mutate(rn = row_number(), .by = Group) %>%
  pivot_wider(names_from = rn, values_from = Rivers, names_prefix = "Rivers")

all.equal(test, result, check.attributes = FALSE, check.names = FALSE)
# TRUE
