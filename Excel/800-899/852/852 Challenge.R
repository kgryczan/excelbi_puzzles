library(tidyverse)
library(readxl)
library(janitor)

path <- "Excel/800-899/852/852 Pivot.xlsx"
input <- read_excel(path, range = "A2:B6")
test  <- read_excel(path, range = "D2:E7")

result = input %>%
  separate_longer_delim(cols = everything(), delim = "-") %>%
  mutate(Amount = as.numeric(Amount)) %>%
  summarise(`Total Amount` = sum(Amount, na.rm = TRUE), .by = Items) %>%
  adorn_totals("row", name = "Grand Total")

all.equal(result, test , check.attributes = FALSE)
# [1] TRUE