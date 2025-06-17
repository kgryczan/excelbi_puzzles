library(tidyverse)
library(readxl)

path = "200-299/296/PQ_Challenge_296.xlsx"
input = read_excel(path, range = "A1:D13")
test = read_excel(path, range = "G1:H8")

result = input %>%
  mutate(row = row_number(), row_oddity = (row + 1) %% 2) %>%
  pivot_longer(
    cols = -c(row, row_oddity),
    names_to = "col",
    values_to = "value"
  )

result2 = bind_cols(
  result %>% filter(row_oddity == 0) %>% select(-row_oddity),
  result %>% filter(row_oddity == 1) %>% select(-row_oddity, value2 = value)
) %>%
  select(Fruits = value, value2) %>%
  mutate(value2 = as.numeric(value2)) %>%
  filter(!is.na(value2)) %>%
  summarise(Sales = sum(value2), .by = Fruits) %>%
  arrange(Fruits) %>%
  add_row(Fruits = "Total", Sales = sum(.$Sales))

all.equal(result2, test, check.attributes = FALSE)
