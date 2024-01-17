library(tidyverse)
library(readxl)

input1 = read_excel("Excel/371 Find data between dates.xlsx", range = "A1:F8")
input2 = read_excel("Excel/371 Find data between dates.xlsx", range = "H1:I2") %>%
  janitor::clean_names()

test = read_excel("Excel/371 Find data between dates.xlsx", range = "H5:I8") 

result = input1 %>%
  pivot_longer(cols = -c("Products"), names_to = "index", values_to = "Dates") %>%
  filter(Dates >= input2$from_date & Dates <= input2$to_date) %>%
  group_by(Dates) %>%
  arrange(Products) %>%
  summarise(Product = paste(Products, collapse = ", ")) 

identical(result, test)  
#> [1] TRUE
