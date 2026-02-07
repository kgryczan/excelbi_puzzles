library(tidyverse)
library(readxl)

path <- "Power Query/300-399/363/PQ_Challenge_363.xlsx"
input1 <- read_excel(path, range = "A1:C16")
input2 <- read_excel(path, range = "E1:G11")
test <- read_excel(path, range = "E16:F26")

res = input2 %>%
  separate_longer_delim(`Order String (Qty x Item)`, delim = ", ") %>%
  separate(`Order String (Qty x Item)`, into = c("Qty", "Item"), sep = "x") %>%
  left_join(input1, by = "Item") %>%
  mutate(Qty = as.numeric(Qty)) %>%
  mutate(
    Total = case_when(
      `Discount Code` == "NONE" ~ Price * Qty,
      `Discount Code` == "SAVE10" ~ (Price * Qty) * 0.9,
      `Discount Code` == "BOGO-DRINK" & Category == "Drink" ~ Price *
        ((Qty + 1) %/% 2),
      TRUE ~ Price * Qty
    )
  ) %>%
  summarise(`Final Total` = sum(Total), .by = `Order ID`)

all.equal(res, test)
#> [1] TRUE
