library(tidyverse)
library(readxl)

path <- "900-999/927/927 Categorization.xlsx"
input <- read_excel(path, range = "A2:E26")
test <- read_excel(path, range = "G2:I8")

result = input %>%
  mutate(revenue = Qty * UnitPrice) %>%
  summarise(total_revenue = sum(revenue), .by = c(Customer, Product)) %>%
  arrange(Customer, desc(total_revenue)) %>%
  mutate(
    Tier = case_when(
      total_revenue >= 200000 ~ "Platinum",
      total_revenue >= 120000 ~ "Gold",
      total_revenue >= 60000 ~ "Silver",
      TRUE ~ "Bronze"
    )
  ) %>%
  slice_max(total_revenue, n = 1, by = Customer) %>%
  select(Customer, `Highest Revenue Generating Product` = Product, Tier)

all.equal(result, test)
#> [1] TRUE
