library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_201.xlsx"
input1 = read_excel(path, range = "A2:C7")
input2 = read_excel(path, range = "A10:C16")
test = read_excel(path, range = "E1:K6")

i1 = input1 %>%
  mutate(date = map2(`Buy Date From`, `Buy Date To`, seq, by = "day")) %>%
  unnest(date) %>%
  select(Buyer, date)

i2 = input2 %>%
  mutate(`Stock Start Date` = replace_na(`Stock Start Date`, min(`Stock Start Date`, na.rm = TRUE)),
         `Stock Finish Date` = replace_na(`Stock Finish Date`, max(i1$date, na.rm = TRUE))) %>%
  mutate(date = map2(`Stock Start Date`, `Stock Finish Date`, seq, by = "day"))  %>%
  unnest(date) %>%
  select(Items, date)

result = i1 %>%
  inner_join(i2, by = c("date")) %>%
  pivot_wider(names_from = Items, values_from = date, values_fn = length) %>%
  select(`Buyer / Items` = 1, sort(colnames(.), decreasing = FALSE)) %>%
  mutate(across(-c(1), ~ifelse(is.na(.), ., "X")))

all.equal(result, test)
# [1] TRUE
