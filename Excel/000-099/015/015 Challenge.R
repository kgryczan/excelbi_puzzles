library(tidyverse)
library(readxl)

path = "Excel/015 Text After Last Digit.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")

result = input %>%
  mutate(`Expected Answer` = str_extract(String, "(?<=\\d)[^0-9]+$")) %>%
  select(`Expected Answer`)

all.equal(result, test)
# [1] TRUE