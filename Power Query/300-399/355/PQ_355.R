library(tidyverse)
library(readxl)

path <- "Power Query/300-399/355/PQ_Challenge_355.xlsx"
input <- read_excel(path, range = "A1:F51")
test <- read_excel(path, range = "H1:K5")

result = input %>%
  transmute(
    Region = Product,
    Quantity = ifelse(!IsReturn, Quantity, -Quantity),
    UnitPrice = UnitPrice
  ) %>%
  summarise(
    `Total Quantity` = sum(Quantity),
    `Total Amount` = sum(Quantity * UnitPrice),
    .by = Region
  ) %>%
  janitor::adorn_totals(where = "row", name = "Total") %>%
  mutate(`Average Price` = round(`Total Amount` / `Total Quantity`, 2))

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE
