library(tidyverse)
library(readxl)

path <- "300-399/386/PQ_Challenge_386.xlsx"
input <- read_excel(path, range = "A1:A22")
test <- read_excel(path, range = "C1:G22")

result <-
  input |>
  separate_wider_delim(
    col = "Data",
    delim = " | ",
    names = c("Product", "Quantity")
  ) %>%
  transmute(
    Level = str_count(Product, "-"),
    Product = str_trim(str_remove_all(Product, "-")),
    `Unit Qty` = as.numeric(str_extract(Quantity, "\\d+"))
  ) %>%
  mutate(`Root Product` = if_else(Level == 0, Product, NA_character_)) %>%
  fill(`Root Product`) %>%
  mutate(
    L1 = if_else(Level == 1, Product, NA_character_),
    L2 = if_else(Level == 2, Product, NA_character_)
  ) %>%
  fill(L1, .by = "Root Product") %>%
  fill(L2, .by = "L1") %>%
  mutate(
    `Direct Parent` = case_when(
      Level == 1 ~ `Root Product`,
      Level == 2 ~ L1,
      Level == 3 ~ L2,
      TRUE ~ NA_character_
    ),
    `Item Name` = case_when(
      Level == 0 ~ `Root Product`,
      Level == 1 ~ L1,
      Level == 2 ~ L2,
      TRUE ~ Product
    )
  ) %>%
  select(Level, `Root Product`, `Direct Parent`, `Item Name`, `Unit Qty`)

all.equal(result, test)
