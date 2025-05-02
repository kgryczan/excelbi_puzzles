library(tidyverse)
library(readxl)

path = "Excel/682 Aggregation at Order No Level.xlsx"
input = read_excel(path, range = "A2:C10")
test  = read_excel(path, range = "E2:G15")

result = input %>%
  separate_rows(`Order No`, sep = ", ") %>%
  mutate(`Order No` = as.numeric(`Order No`), 
         Amount_pc = Amount / n(), .by = Name) %>%
  summarise(Names = paste(unique(Name), collapse = ", "), 
            Amount = sum(Amount_pc, na.rm = TRUE), .by = `Order No`) %>%
  arrange(`Order No`)

# all equal except one field has different sorting of names.