library(tidyverse)
library(readxl)

path = "Power Query/300-399/306/PQ_Challenge_306.xlsx"
input = read_excel(path, range = "A1:E7")
test  = read_excel(path, range = "G1:N5")

result = input %>%
  pivot_longer(-c(1), names_to = "Customer") %>%
  mutate(Amt = min(value[value > 0], na.rm = TRUE), 
         EMI = value/Amt,
         .by = Customer) %>%
  select(-value) %>%
  pivot_wider(names_from = Month, values_from = EMI)

all.equal(result, test, check.attributes = FALSE)  
# > [1] TRUE
