library(tidyverse)
library(readxl)

path = "Excel/200-299/234/234 Check if Digits Divide the Numbers.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B5")

result = input %>%
  mutate(
    digits = map(Number, ~ str_split(as.character(.x), "", simplify = TRUE)),
    is_divisor = map2_lgl(Number, digits, ~ all(.x %% as.numeric(.y) == 0))
  ) %>%
  filter(is_divisor) %>%
  select(Number)

all.equal(result$Number, test$`Expected Answer`, check.attributes = FALSE)
# > [1] TRUE