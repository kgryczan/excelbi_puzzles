library(tidyverse)
library(readxl)

path = "Excel/700-799/795/795 Summarize.xlsx"
input = read_excel(path, range = "A2:C10")
test  = read_excel(path, range = "E2:G6")

result = input %>%
  fill(Supplier) %>%
  summarise(Items = paste0(Items, collapse = " - "),
            Cost = paste0(Cost, collapse = " - "),
            .by = Supplier)

all.equal(result, test)
# > [1] TRUE