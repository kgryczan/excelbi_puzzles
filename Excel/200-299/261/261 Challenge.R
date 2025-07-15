library(tidyverse)
library(readxl)

path = "Excel/200-299/261/261 Previous Number Containing all Prime Digits.xlsx"
input = read_excel(path, range = "A1:A7")
test  = read_excel(path, range = "B1:B7")

digits = c(2, 3, 5, 7)

digits_comb = function(vec, elem, num) {
  tibble(no = as.numeric(apply(expand.grid(rep(list(vec), elem)), 1, paste0, collapse = ""))) %>%
    filter(no < num) %>%
    arrange(desc(no))
}

result = input %>%
  mutate(Previous = map_dbl(Numbers, ~ digits_comb(digits, nchar(.), .) %>% slice(1) %>% pull(no)))

all.equal(result$Previous, test$`Answer Expected`, check.attributes = FALSE)
