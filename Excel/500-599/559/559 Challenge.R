library(tidyverse)
library(readxl)

path = "Excel/559 Max of first N elements.xlsx"
input = read_excel(path, range = "A2:D13")
test  = read_excel(path, range = "F2:I13")

output = input %>% 
  mutate(across(everything(), ~cummax(.))) 

all.equal(output, test, check.attributes = FALSE)
#> [1] TRUE