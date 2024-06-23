library(tidyverse)
library(readxl)

path = "Power Query/PQ Challenge_194.xlsx"
input = read_xlsx(path, range = "A1:D10")
test  = read_xlsx(path, range = "F1:I10")

result = input %>%
  pivot_longer(cols = -c(1), names_to = "Amt", values_to = "Value") %>%
  mutate(val = lag(Value, default = 0),
         diff = Value - val) %>%
  select(-c(Value, val)) %>%
  pivot_wider(names_from = Amt, values_from = diff)

identical(result, test)  
# [1] TRUE