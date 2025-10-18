library(tidyverse)
library(readxl)

path = "Power Query/300-399/331/PQ_Challenge_331.xlsx"
input1 = read_excel(path, range = "A1:H10")
input2 = read_excel(path, range = "J1:K8")
test  = read_excel(path, range = "A15:C26")

result = input1 %>%
  pivot_longer(-c(Customer, Date), 
               names_to  = c(".value", "set"),
               names_pattern = "(Product|Units)(\\d+)") %>%
  left_join(input2, by = c("Product" = "Fruits")) %>%
  na.omit() %>%
  summarise(Amount = sum(Units * Price, na.rm = T), .by = c(Customer, Product)) %>%
  arrange(Customer, Product)

all.equal(result, test)
# [1] TRUE          