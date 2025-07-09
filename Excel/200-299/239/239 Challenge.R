library(tidyverse)
library(readxl)

path = "Excel/200-299/239/239 Vowel Sort.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")

sort_vowels = function(w) {
  v = str_extract_all(w, "[aeiou]")[[1]]
  if (!length(v)) return(w)
  c = strsplit(w, "")[[1]]
  c[which(c %in% v)] = sort(v)
  paste0(c, collapse = "")
}

result = input %>%
  mutate(Sorted = map_chr(Strings, sort_vowels)) 

all.equal(result$Sorted, test$`Expected Answer`)
# > [1] TRUE