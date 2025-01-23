library(tidyverse)
library(readxl)

path = "Excel/636 Repeat Customers in a Year.xlsx"
input = read_excel(path, range = "A2:C90")
test  = read_excel(path, range = "E2:G7")

repeat_customers = input %>%
  mutate(Year = year(Date)) %>%
  summarise(n = n(), .by = c(Year, Customer,Store)) %>%
  filter(n > 1) %>%
  summarise(
            Count = n_distinct(Customer),
            Customers = paste0(unique(sort(Customer)), collapse = ", "),
            .by = c(Year))

all.equal(repeat_customers, test)
#> [1] TRUE