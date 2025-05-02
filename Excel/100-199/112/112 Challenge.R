library(tidyverse)
library(readxl)

path = "Excel/112 Uncommon.xlsx"
input = read_excel(path, range = "A1:B8") %>% janitor::clean_names()
test  = read_excel(path, range = "C1:C8") %>% replace_na(list(Answer = ""))


result = input %>%
  mutate(group_1 = map(group_1, ~strsplit(.x, ", ")[[1]]),
         group_2 = map(group_2, ~strsplit(.x, ", ")[[1]])) %>%
  mutate(intersection = map2(group_1, group_2, intersect)) %>%
  mutate(setdiff_1 = map2(group_1, intersection, setdiff),
         setdiff_2 = map2(group_2, intersection, setdiff)) %>%
  mutate(Answer = map2(setdiff_1, setdiff_2, ~union(.x, .y))) %>%
  mutate(Answer = map(Answer, ~if(length(.x) == 0) "None" else paste(.x, collapse = ", "))) %>%
  mutate(Answer = str_replace_all(Answer, "None|, NA|NA, ", "")) %>%
  select(Answer)

all.equal(result, test)         
#> [1] TRUE