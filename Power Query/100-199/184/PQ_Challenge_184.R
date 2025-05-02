library(tidyverse)
library(readxl)

input = read_excel("Power Query/PQ_Challenge_184.xlsx", range = "A1:B10")
test  = read_excel("Power Query/PQ_Challenge_184.xlsx", range = "D1:G4")

result = input %>%
  mutate(group = str_extract_all(Text,"[A-Za-z]+\\d+")) %>%
  mutate(group = map_chr(group, ~if(length(.x) > 1) tail(.x, 1) else if(length(.x) == 0) NA_character_ else .x)) %>%
  summarise(
      Text = paste(group[!is.na(group)], collapse = "-"),
      `Original Count` = n() %>% as.numeric(),
      `New Count` = sum(!is.na(group)) %>% as.numeric(),
      .by = Set
      )

identical(result, test)
# [1] TRUE