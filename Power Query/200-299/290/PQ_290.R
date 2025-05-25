library(tidyverse)
library(readxl)

path = "Power Query/200-299/290/PQ_Challenge_290.xlsx"
input = read_excel(path, range = "A1:B12")
test = read_excel(path, range = "D1:H4")

result = input %>%
  mutate(group = cumsum(Column1 == "Company")) %>%
  pivot_wider(names_from = "Column1", values_from = "Column2") %>%
  select(Company, Revenue, Cost, Tax, Profit) %>%
  mutate(across(-Company, as.integer)) %>%
  mutate(
    Tax = ifelse(is.na(Tax), 0, Tax),
    Profit = ifelse(is.na(Profit), (Revenue - Cost - Tax), Profit)
  )
