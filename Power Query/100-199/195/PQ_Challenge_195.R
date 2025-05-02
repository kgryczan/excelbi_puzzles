library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_195.xlsx"
input1 = read_xlsx(path, range = "A1:C5")
input2 = read_xlsx(path, range = "A8:B11")                
test = read_xlsx(path, range = "F1:G4")

result1 = input1 %>%
  mutate(across(everything(), ~str_split(.x, "\\W+"))) %>%
  unnest(cols = everything()) %>%
  mutate(total = as.numeric(`Unit Price`) * as.numeric(Quantity)) %>%
  select(Items, total)

result2 = input2 %>%
  mutate(across(everything(), ~str_split(.x, "\\W+"))) %>%
  unnest(cols = everything()) %>%
  mutate(part = n(), .by = Items)

result = result2 %>%
  left_join(result1, by = "Items") %>%
  mutate(paid_by_stockist = total/part) %>%
  summarise(`Amount Paid` = sum(paid_by_stockist, na.rm = T), .by = Stockist)

identical(result, test)
# [1] TRUE