library(tidyverse)
library(readxl)

path <- "900-999/972/Excel_Challenge_972 - Merging.xlsx"
input <- read_excel(path, range = "A1:A20")
test <- read_excel(path, range = "B1:B20")

result = input %>%
  mutate(rn = row_number()) %>%
  separate_longer_delim(Data, delim = ",") %>%
  separate(Data, c("min", "max"), sep = "-", convert = TRUE) %>%
  arrange(rn, min) %>%
  mutate(group = cumsum(coalesce(min > lag(cummax(max)), FALSE)), .by = rn) %>%
  summarise(range = paste0(min(min), "-", max(max)), .by = c(rn, group)) %>%
  summarise(result = paste(range, collapse = ", "), .by = rn) %>%
  select(-rn)

all.equal(result$result, test$`Answer Expected`)
# [1] TRUE
