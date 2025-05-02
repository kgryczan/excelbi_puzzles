library(tidyverse)
library(readxl)

input = read_excel("Power Query/PQ_Challenge_178.xlsx", range = "A1:E5")
test  = read_excel("Power Query/PQ_Challenge_178.xlsx", range = "H1:K5")

result = input %>%
  pivot_longer(-Emp, names_to = "Change", values_to = "Value") %>%
  separate(Change, into = c("Type", "Change"), sep = " ") %>%
  pivot_wider(names_from = Type, values_from = Value) %>%
  drop_na() 

identical(result, test)
# [1] TRUE
