library(tidyverse)
library(readxl)

input = read_excel("Power Query/PQ_Challenge_145.xlsx", range = "A1:C16")
test  = read_excel("Power Query/PQ_Challenge_145.xlsx", range = "F1:I16")

result = input %>%
  group_by(Store) %>%
  mutate(min_date = min(Date),
         year = case_when(
           between(Date, min_date, min_date + years(1)) ~ 1,
           between(Date, min_date + years(1), min_date + years(2)) ~ 2,
           between(Date, min_date + years(2), min_date + years(3)) ~ 3,
           between(Date, min_date + years(3), min_date + years(4)) ~ 4,
           between(Date, min_date + years(4), min_date + years(5)) ~ 5
         )) %>%
  ungroup()  %>%
  group_by(Store, year) %>%
  mutate(Column1 = cumsum(Sale)) %>%
  ungroup() %>%
  select(-year, -min_date)

identical(result, test)
#> [1] TRUE
