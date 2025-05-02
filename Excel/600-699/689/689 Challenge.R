library(tidyverse)
library(readxl)

path = "Excel/689 Consecutive Numbers Marking.xlsx"
input = read_excel(path, range = "A1:B29")
test  = read_excel(path, range = "D1:D29")

result = input %>%
  mutate(rn = row_number()) %>%
  group_by(
    group_id = cumsum(ID != lag(ID, default = first(ID)) | 
                        (Number - rn) != lag(Number - rn, default = first(Number - rn)))
  ) %>%
  mutate(answer_expected = n()) %>%
  ungroup() %>%
  select(answer_expected)

all.equal(result$answer_expected, test$`Answer Expected`)
# TRUE