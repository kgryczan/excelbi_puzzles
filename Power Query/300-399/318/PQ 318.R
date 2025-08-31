library(tidyverse)
library(readxl)

path = "Power Query/300-399/318/PQ_Challenge_318.xlsx"
input = read_excel(path, sheet = 2, range = "A1:F7")
test  = read_excel(path, sheet = 2, range = "A11:E17")

result = input %>%
  pivot_longer(cols = -Alphabet, names_to = "Attribute", values_to = "Value") %>%
  select(-Attribute) %>%
  mutate(r = str_extract(Value, 'R[0-9]+'),
         c = str_extract(Value, 'C[0-9]+')) %>%
  na.omit() %>%
  arrange(r, c) %>%
  pivot_wider(names_from = c, values_from = Alphabet, id_cols = r) 

all.equal(result, test, check.attributes = FALSE)
