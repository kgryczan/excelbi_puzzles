library(tidyverse)
library(readxl)

path = "Power Query/300-399/330/PQ_Challenge_330.xlsx"
input = read_excel(path, range = "A1:B35")
test  = read_excel(path, range = "D1:F12")

result = input %>%
  mutate(Year = ifelse(Data1 == "Year", Data2, NA)) %>%
  fill(Year) %>%
  filter(str_detect(Data1, "Year|TOTAL|Continent", negate = TRUE),
         Data2 > 0) %>%
  select(Continent = Data1, Year, Sales = Data2) %>%
  mutate(across(c(Year, Sales), as.integer)) 

all.equal(result, test)
# [1] TRUE