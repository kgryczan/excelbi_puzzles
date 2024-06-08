library(tidyverse)
library(readxl)

input = read_excel("Power Query/PQ_Challenge_189.xlsx", range = "A1:B11")
test  = read_excel("Power Query/PQ_Challenge_189.xlsx", range = "D1:F8")

result = input %>%
  mutate(Result = if_else(lead(Code) == "Yes", "Pass", NA)) %>%
  mutate(Result = if_else(is.na(Result) & str_detect(Code, "\\d"), "Fail", Result)) %>%
  filter(!is.na(Result)) %>%
  mutate(Code = as.numeric(Code))

identical(result, test)
# [1] TRUE