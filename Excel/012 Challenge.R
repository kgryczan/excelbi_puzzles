library(tidyverse)
library(readxl)

path = "Excel/012 List Second Name with C.xlsx"
input = read_excel(path, range = "A1:A20")
test  = read_excel(path, range = "B1:B6")

result = input %>%
  separate(col = "Names", into = c("First", "Last"), sep = " ", remove = FALSE) %>%
  filter(str_starts(Last, "C")) %>%
  select(Names)

identical(result$Names, test$`Expected Answer`)
# [1] TRUE