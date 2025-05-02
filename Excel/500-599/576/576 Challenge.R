library(tidyverse)
library(readxl)

path = "Excel/576 Sort only Consonants.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")


process_column <- function(word) {
  col <- strsplit(word, "")[[1]]
  consonant_pos <- grep("[b-df-hj-np-tv-z]", col)
  sorted_consonants <- sort(col[consonant_pos])
  col[consonant_pos] <- sorted_consonants
  paste(col, collapse = "") 
}

result = input %>%
  mutate(result = map_chr(Sentences, process_column))
                                                                                      
all.equal(result$result, test$`Answer Expected`, check.attributes = FALSE)
#   [1] TRUE