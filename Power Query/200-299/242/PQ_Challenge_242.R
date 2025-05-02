library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_242.xlsx"
input = read_excel(path, range = "A1:F5")
test  = read_excel(path, range = "H1:I16") 

result = input %>%
  mutate(across(everything(), as.character)) %>%
  mutate(no = row_number() %>% as.character(), .by = Hall) %>%
  unite(Hall, Hall, no, sep = "_") %>%
  pivot_longer(everything(), names_to = "name", values_to = "value") %>%
  filter(!is.na(value), !str_ends(value, "_2")) %>%
  mutate(value = str_remove(value, "_1"))

colnames(result) = colnames(test)

all.equal(result, test, check.attributes = FALSE)         
# not equal because of wrong formating of dates in equipment.