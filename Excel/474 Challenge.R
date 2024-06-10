library(tidyverse)
library(readxl)

input = read_excel("Excel/474 Wavy Numbers.xlsx", range = "A1:A10")
test  = read_excel("Excel/474 Wavy Numbers.xlsx", range = "B1:B6")

is_wavy <- function(number) {
  digits <- str_split(as.character(number), "")[[1]] %>% as.numeric()
  differences <- diff(digits)
  signs <- sign(differences)
  if (length(signs) < 2) {
    return(FALSE)
  }
  all(abs(diff(signs)) == 2)
}

result = input %>%
  mutate(wavy = map_lgl(Numbers, is_wavy)) %>%
  filter(wavy) %>%
  select(`Answer Expected` = Numbers)

identical(result, test)
# [1] TRUE