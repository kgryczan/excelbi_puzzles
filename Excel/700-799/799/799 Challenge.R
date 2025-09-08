library(tidyverse)
library(readxl)

path = "Excel/700-799/799/799 Remove Characters between 2 Asterisks.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")

strip_star_pairs = function(x) {
  while (str_detect(x, "\\*[^*]*\\*")) {
    x = str_replace(x, "\\*([^*]*)\\*", ~str_remove_all(.x, "[A-Za-z]+"))
  }
  str_remove_all(x, "\\*")
}

result = input %>%
  mutate(answer = map_chr(Data, strip_star_pairs))

all.equal(result$answer, test$`Answer Expected`)
# [1] TRUE