library(tidyverse)
library(readxl)

path = "Excel/200-299/269/269 Remove Consecutive Numbers.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10") %>% na.omit()

result = input %>%
  mutate(dig = str_split(Numbers, pattern = "")) %>%
  unnest(dig) %>%
  mutate(gr = consecutive_id(dig), .by = Numbers) %>%
  mutate(n = n(), .by = c(Numbers, gr)) %>%
  filter(n == 1) %>%
  summarise(Numbers = paste(dig, collapse = "") %>% as.numeric(), .by = Numbers) 

all.equal(result$Numbers, test$`Answer Expected`, check.attributes = FALSE)
#> [1] TRUE