library(tidyverse)
library(readxl)

path = "Excel/122 Long Addition.xlsx"
input = read_excel(path, range = "A1:B13")
test  = read_excel(path, range = "C1:C13", col_types = "numeric")

result = input %>%
  mutate(result = as.numeric(Number1) + as.numeric(Number2))

all.equal(result$result, test$Result)
#> [1] TRUE