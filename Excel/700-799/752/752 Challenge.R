library(tidyverse)
library(readxl)

path = "Excel/700-799/752/752 Sort on Maximum Digits.xlsx"
input = read_excel(path, range = "A1:A11")
test  = read_excel(path, range = "B1:B11")

result = input %>%
       mutate(Sorted = str_split(Numbers, "") %>%
                map_chr(~ paste0(sort(.x, decreasing = TRUE), collapse = ""))) %>%
       arrange(desc(Sorted)) %>%
  select(-Sorted)

all.equal(result$Numbers, test$`Answer Expected`, check.attributes = FALSE)
# > [1] TRUE