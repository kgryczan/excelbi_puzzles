library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_197.xlsx"

input = read_xlsx(path, range = "A1:E21")
test  = read_xlsx(path, range = "H1:N21")

result <- input %>%
  group_by(Item, Store) %>%
  mutate(data = accumulate(`Stock IN` - `Stock OUT`, `+`, .init = 0)[-1],
         `Start Stock` = lag(data, default = first(`Stock IN`)),
         `End Stock` = data) %>%
  ungroup() %>%
  select(-data) 

identical(result, test)
#> [1] TRUE