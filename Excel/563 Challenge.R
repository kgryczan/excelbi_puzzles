library(tidyverse)
library(readxl)

path = "Excel/563 Bands of Numbers.xlsx"
input = read_excel(path, range = "A2:B17")
test  = read_excel(path, range = "D2:F6")

result = input %>%
  mutate(Group = cumsum(c(1, diff(Numbers)) != 1), .by = Product) %>%
  mutate(Band = ifelse(n() == 1, paste0(Numbers), paste0(Numbers[1], "-", Numbers[n()])), 
         .by = c(Product, Group)) %>%
  summarise(Bands = paste0(unique(Band), collapse = ", "), 
            Count = n_distinct(Band), 
            .by = Product)

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE