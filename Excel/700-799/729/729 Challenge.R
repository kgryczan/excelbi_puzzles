library(tidyverse)
library(readxl)

path = "Excel/700-799/729/729 Extract Text Between Delimiters.xlsx"
input = read_excel(path, range = "A1:A10")
test = read_excel(path, range = "B1:B10") %>%
  replace_na(list(`Answer Expected` = ""))

result = input %>%
  rowwise() %>%
  mutate(
    `Answer Expected` = list(str_match_all(Text, "(?<=~)\\w+(?=~)")[[1]]) %>%
      unlist() %>%
      paste(collapse = ", ")
  )

all.equal(result$`Answer Expected`, test$`Answer Expected`)
#> TRUE
