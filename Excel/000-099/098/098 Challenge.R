library(tidyverse)
library(readxl)

path = "Excel/098 Combinations for Sum.xlsx"
input1 = read_excel(path, range = "A1:A10")
input2 = read_excel(path, range = "C1:C8")
test  = read_excel(path, range = "D1:D8") %>% replace_na(list(Answer = ""))

comb = expand.grid(input1$Numbers, input1$Numbers) %>%
  filter(Var1 != Var2,
         Var1 < Var2) %>%
  mutate(Combination = paste(Var1, Var2, sep = "+"),
         Sum = Var1 + Var2)

result = input2 %>%
  left_join(comb, by = "Sum") %>%
  replace_na(list(Combination = "")) %>%
  arrange(Sum, Var1) %>%
  summarise(Answer = first(Combination), .by = Sum) %>%
  select(Answer)

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE