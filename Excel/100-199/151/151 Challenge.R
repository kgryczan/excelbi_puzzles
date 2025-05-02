library(tidyverse)
library(readxl)

path = "Excel/151 Common Digits.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10") %>% replace_na(list(`Answer Expected` = ""))

has_common_digit = function(vec) {
  vec %>%
    map(~ str_split(.x, "", simplify = TRUE)) %>%
    reduce(intersect)
}

result = input %>%
  mutate(Numbers = str_split(Numbers, ", ")) %>% 
  mutate(HasCommonDigit = map(Numbers, has_common_digit)) %>%
  mutate(result = map_chr(HasCommonDigit, ~ str_c(sort(.x), collapse = ", ")))

all.equal(result$result, test$`Answer Expected`, check.attributes = FALSE)
#> [1] TRUE