library(tidyverse)
library(readxl)

path = "Excel/092 Cities Avg Cost.xlsx"
input = read_excel(path, range = "A1:D11")
test  = read_excel(path, range = "F2:H7")

result = input %>%
  mutate(City1 = pmin(`City 1`, `City 2`), 
         City2 = pmax(`City 1`, `City 2`)) %>%
  summarise(`Average Cost` = mean(Cost), .by = c(City1, City2)) %>%
  arrange(desc(`Average Cost`))

identical(result, test)
#> [1] TRUE