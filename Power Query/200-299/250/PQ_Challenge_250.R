library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_250.xlsx"
input = read_excel(path, range = "A1:E9")
test  = read_excel(path, range = "A14:F22")

result  = input %>%
  group_by(Product) %>%
  mutate(`Finish Stock` = cumsum(ifelse(row_number() == 1, `Starting Stock`, 0) + `In Stock` - `Out Stock`),
         `Starting Stock` = ifelse(row_number() == 1, `Starting Stock`, lag(`Finish Stock`)))

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE