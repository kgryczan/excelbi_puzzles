library(tidyverse)
library(readxl)

path = "Excel/154 Roman to Numbers.xlsx"
input = read_excel(path, range = "A1:A11")
test  = read_excel(path, range = "B1:B11")

roman_to_arabic = function(roman) {
  values = c(I = 1, V = 5, X = 10, L = 50, C = 100, D = 500, M = 1000)
  numerals = unlist(strsplit(roman, ""))
  arabic_values = values[numerals]
  total = 0
  for (i in seq_along(arabic_values)) {
    if (i < length(arabic_values) && arabic_values[i] < arabic_values[i + 1]) {
      total = total - arabic_values[i]
    } else {
      total = total + arabic_values[i]
    }
  }
  
  return(total)
}

result = input %>%
  mutate(arabic = map_dbl(Roman, roman_to_arabic))

all.equal(result$arabic, test$Number, check.attributes = FALSE)
#> [1] TRUE