library(tidyverse)
library(readxl)

path = "Excel/594 Capitalize at Same Indexes.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")

result = input %>%
  mutate(pos = str_locate_all(Sentences, "[A-Z]")) %>%
  mutate(answer = str_to_lower(Sentences) %>%
           str_remove_all("[^a-z]") %>%
           str_split("")) %>%
  mutate(answer = map2(answer, pos, ~{
    .x[.y] = toupper(.x[.y]) 
    .x
  })) %>%
  mutate(answer = map_chr(answer, ~{
    paste(.x[!is.na(.x)], collapse = "")
  }))

all.equal(result$answer, test$`Answer Expected`)
#> [1] TRUE          