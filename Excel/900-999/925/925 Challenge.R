library(tidyverse)
library(readxl)
library(glue)

path <- "900-999/925/925 Max Order.xlsx"
input1 <- read_excel(path, range = "A1:C7")
input2 <- read_excel(path, range = "E1:F4")
test <- read_excel(path, range = "G1:G4")

i1 = input1 %>%
  fill(everything(), .direction = "down")
mains = i1 %>% filter(Category == "Mains")
dnd = i1 %>%
  filter(Category != "Mains") %>%
  add_row(Category = "DND", Item = "", Price = 0)

deal = expand.grid(mains$Item, dnd$Item) %>%
  left_join(i1, by = c("Var1" = "Item")) %>%
  left_join(i1, by = c("Var2" = "Item")) %>%
  rowwise() %>%
  transmute(
    deal = paste0(c(Var1, Var2), collapse = ", ") %>%
      str_replace_all(", $", "") %>%
      str_replace_all("^, ", ""),
    price = Price.x + coalesce(Price.y, 0)
  )

result = input2 %>%
  cross_join(deal) %>%
  filter(price <= Amount) %>%
  slice_max(price, n = 1, by = Name) %>%
  select(`Answer Expected` = deal)

all.equal(result$`Answer Expected`, test$`Answer Expected`)
## [1] TRUE
