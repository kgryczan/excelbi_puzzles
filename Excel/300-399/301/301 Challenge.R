library(tidyverse)
library(readxl)

input = read_excel("Polydivisible Numbers.xlsx", range = "A1:A10")
test= read_excel("Polydivisible Numbers.xlsx", range = "B1:B6")

is_polydivisible = function(number) {
  digits = str_split(number, "")[[1]]
  
  map_lgl(1:length(digits), function(x)
  {
    num = as.numeric(paste0(digits[1:x], collapse = "")) 
    num %% x == 0 
  }) %>%
    all()
}

result = input %>%
  mutate(check = map_lgl(Number, is_polydivisible)) %>% 
  filter(check) %>%
  select(`Expected Answer` = Number)

identical(test, result)
#> [1] TRUE