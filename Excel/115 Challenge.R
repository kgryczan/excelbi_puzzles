library(tidyverse)
library(readxl)

path = "Excel/115 Beautiful Strings.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B5")

is_beautiful = function(string) {
  digits = strsplit(string, "")[[1]] %>% as.numeric()
  diffs = abs(diff(digits))
  all(diffs == 1)
}

result = input %>%
  mutate(is_beautiful = map_lgl(Strings, is_beautiful)) %>%
  filter(is_beautiful)

all.equal(test$`Answer Expected`, result$Strings, check.attributes = FALSE)
#> [1] TRUE