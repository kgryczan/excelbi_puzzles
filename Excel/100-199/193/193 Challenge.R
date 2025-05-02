library(tidyverse)
library(readxl)
library(rlang)

path = "Excel/193 Missing Letters.xlsx"
input = read_excel(path, range = "A1:A8")
test  = read_excel(path, range = "B1:B8") %>% replace_na(list(`Answer Expected` = ""))

result = input %>%
  mutate(rn = row_number()) %>%
  separate_rows(String, sep = "") %>%
  filter(String != "") %>%
  mutate(Alphabet = match(String, letters)) %>%
  mutate(min_ind = min(Alphabet),
         max_ind = max(Alphabet),
         range = paste0(min_ind, ":", max_ind),
         .by = rn) %>%
  summarise(String = paste(String, collapse = ""),
            Alphabet = list(Alphabet),
            range = first(range), 
            .by = rn) %>%
  mutate(range = map(range, ~eval(parse_expr(.x)))) %>%
  mutate(Missing = map2(Alphabet, range, ~setdiff(.y, .x))) %>%
  mutate(Missing = map2_chr(Missing, test, ~if(length(.x) == 0) "" else paste(letters[.x], collapse = ", "))) %>%
  select(String, Missing)

all.equal(result$Missing, test$`Answer Expected`, check.attributes = FALSE)
#> [1] TRUE