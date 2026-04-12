library(tidyverse)
library(readxl)

path <- "300-399/382/PQ_Challenge_382.xlsx"
input <- read_excel(path, range = "A1:D22")
test <- read_excel(path, range = "G1:H3")

joined = input %>%
  left_join(input, by = c("Component" = "Parent Assembly")) %>%
  left_join(input, by = c("Component.y" = "Parent Assembly")) %>%
  filter_out(Component.x %in% Component.y | Component.x %in% Component.y.y) %>%
  mutate(
    Unit_Cost = coalesce(`Unit Cost.x`, coalesce(`Unit Cost.y`, `Unit Cost`)),
    Quantity = coalesce(Qty.x, 1) * coalesce(Qty.y, 1) * coalesce(Qty, 1)
  ) %>%
  mutate(Total_Cost = Unit_Cost * Quantity) %>%
  summarise(Total_Cost = sum(Total_Cost), .by = `Parent Assembly`) %>%
  rename(`Top Level Assembly` = `Parent Assembly`, `Total Cost` = Total_Cost)

all(joined == test)
## [1] TRUE
