library(tidyverse)
library(readxl)

path = "Excel/018 Triangle or not.xlsx"
input = read_excel(path, range = "A1:D10")
test  = read_excel(path, range = "F1:F5")

result = input %>%
  pivot_longer(-Triangle, names_to = "Side", values_to = "Length") %>%
  arrange(Triangle, desc(Length)) %>%
  select(-Side) %>%
  mutate(nr = row_number(), .by = Triangle) %>%
  pivot_wider(names_from = nr, values_from = Length, names_prefix = "side_") %>%
  filter(side_1 < side_2 + side_3) %>%
  select(Triangle)

identical(result$Triangle, test$`Answer Expected`)
# [1] TRUE