library(tidyverse)
library(readxl)

path <- "400-499/408/PQ_Challenge_408.xlsx"
input <- read_excel(path, range = "A1:C22")
test <- read_excel(path, range = "E1:F4")

result <- input %>%
  separate_wider_delim(
    Data,
    names = c("Quantity", "LocalPrice", "Currency", "Status"),
    delim = ";"
  ) %>%
  mutate(
    Quantity = as.numeric(Quantity),
    LocalPrice = as.numeric(LocalPrice)
  ) %>%
  mutate(
    USD = case_when(
      Currency == "EUR" ~ LocalPrice * 1.1,
      Currency == "GBP" ~ LocalPrice * 1.3,
      TRUE ~ LocalPrice
    )
  ) %>%
  filter(Status == "Completed") %>%
  arrange(Category, Date) %>%
  slice_tail(n = 3, by = Category) %>%
  summarise(
    `Weighted Avg USD` = sum(Quantity * USD) / sum(Quantity),
    .by = Category
  )

# only one value matches
