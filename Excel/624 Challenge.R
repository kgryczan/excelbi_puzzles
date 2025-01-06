library(tidyverse)
library(readxl)

path = "Excel/624 Top 3 Highest Sales.xlsx"
input = read_excel(path, range = "A1:C20")
test  = read_excel(path, range = "E1:G5")

result = input %>%
  summarise(Amount = sum(Amount), .by = c(Customer, Date)) %>%
  filter(dense_rank(desc(Amount)) <= 3) %>%
  arrange(desc(Amount), Date) 

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE