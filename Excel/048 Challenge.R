library(tidyverse)
library(readxl)

path = "Excel/048 Sort Cities.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")

result = input %>%
  separate(Cities, into = c("City", "SecWord"), sep = " ", remove = F) %>%
  arrange(stringi::stri_reverse(City)) %>%
  select(Cities)

identical(result$Cities, test$`Answer Expected`)
#> [1] TRUE