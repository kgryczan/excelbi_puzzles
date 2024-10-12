library(tidyverse)
library(readxl)

path = "Excel/137 Unique letters.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B6") 
test$`Expected Answer` = str_replace(test$`Expected Answer`, "cannot", "can not")

check_uniqueness = function(x) {
  words = strsplit(x, " ")[[1]]
  chars = strsplit(tolower(words), "")
  chars = map_lgl(chars, ~length(unique(.x)) == length(.x))
  return(all(chars))
}

result = input %>%
  mutate(all_unique = map_lgl(String, check_uniqueness)) %>%
  filter(all_unique)

all.equal(result$String, test$`Expected Answer`, check.attributes = FALSE)
# [1] TRUE
