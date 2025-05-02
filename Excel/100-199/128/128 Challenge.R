library(tidyverse)
library(readxl)

path = "Excel/128 Split the Words.xlsx"
input = read_excel(path, range = "A1:A8")
test  = read_excel(path, range = "B1:B8")

split_words = function(x) {
  x = strsplit(x, "(?<=[0-9])(?=[A-Za-z])|(?<=[A-Za-z])(?=[0-9])", perl = TRUE)
  x = unlist(x)
  x = x[x != ""]
  x = str_c(x, collapse = " ")
  return(x)
}

result = input %>%
  mutate(Answer = map_chr(String, split_words))

all.equal(result$Answer, test$Answer)
#> [1] TRUE