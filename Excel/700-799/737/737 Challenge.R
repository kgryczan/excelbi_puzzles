library(tidyverse)
library(readxl)

path = "Excel/700-799/737/737 Split Text on Transition.xlsx"
input = read_excel(path, range = "A2:A6")
test = read_excel(path, range = "B2:F6")

result = input %>%
  mutate(
    Value = str_split(Text, "(?<=[A-Za-z])-(?=\\d)|(?<=\\d)-(?=[A-Za-z])")
  ) %>%
  unnest_wider(Value, names_sep = "") %>%
  select(-Text)

all.equal(result, test)
# [1] TRUE
