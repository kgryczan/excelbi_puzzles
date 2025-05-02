library(tidyverse)
library(readxl)

path = "Excel/152 Remove Words.xlsx"
input = read_excel(path, range = "A1:B10")
test  = read_excel(path, range = "C1:C10") %>% replace_na(list(`Answer Expected` = ""))

extract_by_indices = function(input, indices) {
  words = str_split(input, ", ")[[1]]
  indices = str_split(indices, ", ")[[1]] %>% as.integer()
  if(length(indices) == 1 && indices == 0) return(words)
  else return(words[-indices])
}

result = input %>%
  rowwise() %>%
  mutate(result = map(Index, ~extract_by_indices(Words, .x))) %>%
  ungroup() %>%
  mutate(result = map_chr(result, ~paste(.x, collapse = ", ")))

all.equal(result$result, test$`Answer Expected`, check.attributes = FALSE)
# [1] TRUE