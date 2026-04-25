library(tidyverse)
library(readxl)

path <- "900-999/959/959  SKU Pairing.xlsx"
input <- read_excel(path, range = "A2:B36")
test <- read_excel(path, range = "D2:F23")

coocurence <- input %>%
  inner_join(input, by = "TxnID", suffix = c("", ".1")) %>%
  count(SKU, SKU.1) %>%
  filter(SKU < SKU.1)

colnames(coocurence) <- colnames(test)
all.equal(coocurence, test)
# True
