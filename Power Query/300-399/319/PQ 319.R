library(tidyverse)
library(readxl)

path = "Power Query/300-399/319/PQ_Challenge_319.xlsx"
input = read_excel(path, sheet = 2,  range = "A1:I4")
test  = read_excel(path, sheet = 2, range = "A9:F18")

result = input %>%
  pivot_longer(-Fruits,
               names_to = c("Q", ".value"),
               names_sep = "-") %>%
  mutate(Total = Price * Quantity) %>%
  pivot_longer(-c(Fruits, Q),
               names_to = "Quarters",
               values_to = "Values") %>%
  pivot_wider(names_from = Q,
              values_from = Values) %>%
  mutate(Fruits = ifelse(row_number() == 1, Fruits, NA_character_), .by = Fruits)

all.equal(result, test)
# > [1] TRUE