library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_223.xlsx"
input = read_excel(path, range = "A1:D14")
test  = read_excel(path, range = "F1:J8")

result = input %>%
  unite("Code", c("Type", "Code"), sep = "") %>%
  mutate(col = ifelse(row_number() %% 2 == 0, 2, 1), 
         row = (row_number() + 1) %/% 2,
         .by = Group) %>%
  pivot_wider(names_from = col, values_from = c(Code, Value), names_sep = "") %>%
  select(-row)

all.equal(result, test)
#> [1] TRUE