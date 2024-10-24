library(tidyverse)
library(readxl)

path = "Excel/150 Highest Percentage Growth Years.xlsx"
input = read_excel(path, range = "A1:B10")
test  = read_excel(path, range = "D2:E5")

result = input %>%
  mutate(yoy = round((Revenue - lag(Revenue)) / lag(Revenue),2)) %>%
  slice_max(yoy, n = 3) %>%
  select(Year, yoy)

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE