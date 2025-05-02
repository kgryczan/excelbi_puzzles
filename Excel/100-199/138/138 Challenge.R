library(tidyverse)
library(readxl)

path = "Excel/138 US Presidents_4.xlsx"
input = read_excel(path, range = "A1:A47")
test  = read_excel(path, range = "B2:C11") %>%
  arrange(desc(Frequency), Alphanet)

result = input %>%
  separate_rows(`US Presidents`, sep = " ") %>%
  mutate(Alphanet = str_sub(`US Presidents`, 1, 1)) %>%
  summarise(Frequency = n(), .by = Alphanet) %>%
  filter(dense_rank(desc(Frequency)) <= 5) %>%
  arrange(desc(Frequency), Alphanet) 

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE