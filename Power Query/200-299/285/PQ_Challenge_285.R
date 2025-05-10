library(tidyverse)
library(readxl)
library(unpivotr)
library(tidyxl)

path = "Power Query/200-299/285/PQ_Challenge_285.xlsx"
test = read_excel(path, range = "A10:F16")

input = xlsx_cells(path)

cells_subset <- input %>%
  filter(row >= 1 & row <= 5, col >= 1 & col <= 9)

result = cells_subset %>%
  behead("up", "Quarter") %>%
  behead("up-left", "Measure") %>%
  behead("left", "Fruits") %>%
  select(Quarter, Measure, Fruits, numeric) %>%
  fill(Quarter, .direction = "down") %>%
  pivot_wider(names_from = Quarter, values_from = numeric) %>%
  select(Fruits, Quarters = Measure, everything()) %>%
  arrange(Fruits) %>%
  mutate(Fruits = ifelse(Quarters == "Quantity", NA, Fruits))

all.equal(result, test)
# TRUE
