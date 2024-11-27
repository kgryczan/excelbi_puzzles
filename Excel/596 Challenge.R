library(tidyverse)
library(readxl)
 
path = "Excel/596 Increment Sequences.xlsx"
input = read_excel(path, range = "A1:A18")
test = read_excel(path, range = "B1:B18")

result = input %>%
  mutate(nr = consecutive_id(Alphabets)) %>%
  mutate(nr2 = dense_rank(nr), .by = Alphabets) %>%
  mutate(`Answer Expected` = ifelse(is.na(Alphabets), 0, nr2))


all.equal(result$`Answer Expected`, test$`Answer Expected`)
#> [1] TRUE