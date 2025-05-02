library(tidyverse)
library(readxl)

path = "Excel/172 Missing Alphabets.xlsx"
input = read_excel(path, range = "A1:A48")
test  = read_excel(path, range = "B1:B4")

r1 = input %>%
  pull(`First Ladies`) %>%
  str_to_lower() %>%
  str_split("") %>%
  unlist() %>%
  unique() %>%
  setdiff(c(" ", ",", ".", "!", "?")) %>%
  setdiff(letters, .) 

result = tibble(
  `Answer Expected` = r1
)

all.equal(result, test)
#> [1] TRUE