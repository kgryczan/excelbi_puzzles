library(tidyverse)
library(readxl)

path = "Excel/139 Vowel Finish Start.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B5")

result = input %>%
  filter(str_count(Sentence, "[aeiou] [aeiou]") == 1)

all.equal(result$Sentence, test$`Answer Expected`, check.attributes = FALSE)
#> [1] TRUE