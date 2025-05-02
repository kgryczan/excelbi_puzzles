library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_205.xlsx"
input1 = read_excel(path, range = "A2:B13")
input2 = read_excel(path, range = "D2:E13")
test = read_excel(path, range = "H2:L8")

input = left_join(input1, input2, by = "Item") 

result = input %>%
  arrange(desc(YesNo), Item) %>%
  mutate(nr = row_number(), .by = YesNo) %>%
  mutate(nr_rem = nr %% 2,
         nr_int = ifelse(nr_rem == 1, nr %/% 2 + 1,  nr %/% 2)) %>%
  select(-nr) %>%
  pivot_wider(names_from = nr_rem, values_from = c(Item, Value), 
              values_fill = list(Value = 0)) %>%
  mutate(Sum = Value_0 + Value_1) %>%
  select(YesNo, Item1 = Item_1, Item2 = Item_0, Sum) %>%
  mutate(`%age` = Sum/sum(Sum), .by = YesNo) 

identical(result, test)
# [1] TRUE