library(tidyverse)
library(readxl)

path = "Excel/800-899/846/846 Circular Number Replacements.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")

shift_digits = function(s) {
  m = str_extract_all(s, "\\d+")[[1]]
  if (!length(m)) return(s)
  p = str_split(s, "\\d+")[[1]]
  paste0(rbind(p, c(m[-1], m[1], "")), collapse = "")
}

result = input %>%
  mutate(shifted = map_chr(Data, shift_digits))

all.equal(result$shifted, test$`Answer Expected`)
# [1] TRUE