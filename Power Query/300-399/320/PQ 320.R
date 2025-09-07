library(tidyverse)
library(readxl)

path = "Power Query/300-399/320/PQ_Challenge_320.xlsx"
input = read_excel(path, range = "A1:C13")
test  = read_excel(path, range = "E1:I5")

result = input %>%
  fill(Customer) %>%
  filter(Customer != "Total") %>%
  pivot_wider(names_from = Quarter, 
              names_glue = "{Quarter} {.value}", 
              values_from = Amount)

all.equal(result, test) # TRUE
