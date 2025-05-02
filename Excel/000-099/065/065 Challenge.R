library(tidyverse)
library(readxl)

path = "Excel/065 Triangle Type.xlsx"
input = read_excel(path, range = "A1:D10")
test  = read_excel(path, range = "E1:E10")

result = input %>% 
  mutate(
    type = case_when(
      `Side 1` == `Side 2` & `Side 2` == `Side 3` ~ "E",
      `Side 1` == `Side 2` | `Side 2` == `Side 3` | `Side 1` == `Side 3` ~ "I",
      TRUE ~ "S"
    )
  )

identical(result$type, test$`Answer Expected`)
#> [1] TRUE