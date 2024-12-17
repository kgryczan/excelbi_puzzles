library(tidyverse)
library(readxl)

path = "Excel/610 Uncommon Words in Sentences.xlsx"
input = read_excel(path, range = "A1:B9")
test  = read_excel(path, range = "C1:C9")

count_unique <- function(s1, s2) {
  sum(table(unlist(strsplit(c(s1, s2), "\\s+"))) == 1)
}
         
result = input %>%
  mutate(count = map2_dbl(Sentence1, Sentence2, count_unique)) 

all.equal(result$count, test$`Answer Expected`)
#> [1] TRUE