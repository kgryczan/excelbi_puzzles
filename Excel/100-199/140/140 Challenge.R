library(tidyverse)
library(readxl)

path = "Excel/140 Common Letters.xlsx"
input = read_excel(path, range = "A1:B11")
test  = read_excel(path, range = "C1:C11") %>% replace_na(list(`Answer Expected` = ""))

result = input %>%
  mutate(Word1 = map_vec(Word1, ~strsplit(.x, "")),
         Word2 = map_vec(Word2, ~strsplit(.x, "")),
         Diff  = map2(Word1, Word2, intersect)) %>%
    mutate(Diff = map_chr(Diff, ~paste(sort(unlist(.x)), collapse = ", ")))
  
all.equal(result$Diff, test$`Answer Expected`)
#> [1] TRUE