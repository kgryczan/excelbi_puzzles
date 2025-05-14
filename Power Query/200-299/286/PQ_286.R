library(tidyverse)
library(readxl)

path = "Power Query/200-299/286/PQ_Challenge_286.xlsx"
input = read_excel(path, range = "A1:C6")
test = read_excel(path, range = "F1:H13")

result = input %>%
  mutate(rn = row_number()) %>%
  separate_rows(1:3, sep = ", ") %>%
  group_by(rn, Food) %>%
  mutate(
    Amount = ifelse(
      n_distinct(Animals) > n_distinct(Food) & n_distinct(Amount) == 1,
      as.numeric(Amount) / n_distinct(Animals),
      as.numeric(Amount)
    )
  ) %>%
  ungroup() %>%
  select(Animal = Animals, Food, Amount)

all.equal(result, test, check.attributes = FALSE)
# TRUE
