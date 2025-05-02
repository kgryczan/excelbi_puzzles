library(tidyverse)
library(readxl)

path = "Excel/168 Position of Uppercase.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10") %>% replace_na(list(`Expected Answer` = ""))

result = input %>%
  mutate(positions = map(Words, ~str_locate_all(., "[A-Z]")[[1]][,1])) %>%
  mutate(positions = map_chr(positions, ~str_c(., collapse = "-")))

all.equal(result$positions, test$`Expected Answer`)
#> [1] TRUE