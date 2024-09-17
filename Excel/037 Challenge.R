library(tidyverse)
library(readxl)

path = "Excel/037 Sum of Continents.xlsx"
input1 = read_excel(path, range = "A1:B9")
input2 = read_excel(path, range = "D1:E12")
test  = read_excel(path, range = "G2:H6")

r1 = input1 %>%
  mutate(City = str_to_title(City)) %>%
  left_join(input2, by = "City") %>%
  summarise(Sales = sum(Sales, na.rm = TRUE), .by = Continent) %>%
  arrange(desc(Sales))

identical(r1, test)
# [1] TRUE