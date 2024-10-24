library(tidyverse)
library(readxl)
library(lubridate)

path = "Excel/572 Pivot Problem.xlsx"
input = read_excel(path, range = "A1:B14")
test  = read_excel(path, range = "D2:I7")

result = input %>%
  mutate(Date = as.Date(Date),
         Week = ceiling((day(Date) - 1) %/% 7 + 1)) %>%
  pivot_wider(names_from = Value, values_from = Date, values_fn = length, values_fill = 0) %>%
  select(Week, `1`,`2`,`3`,`4`,`5`) 

all.equal(result, test)
#> [1] TRUE                                                                           