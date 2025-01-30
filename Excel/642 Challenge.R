library(tidyverse)
library(readxl)

path = "Excel/642 List Alphabets and Numbers.xlsx"
input = read_excel(path, range = "A2:A22")
test  = read_excel(path, range = "B2:C8")

result = input %>%
  mutate(group = consecutive_id(str_detect(Data, "^[a-z]"))) %>%
  summarise(Data = paste(Data, collapse = ", "), .by = group) %>%
  mutate(type = ifelse(group %% 2 == 0, "Number", "Alphabet"),
         group2 = ceiling(group / 2)) %>%
  select(-group) %>%
  pivot_wider(names_from = type, values_from = Data) %>%
  select(-group2)

all.equal(result, test)
#> [1] TRUE