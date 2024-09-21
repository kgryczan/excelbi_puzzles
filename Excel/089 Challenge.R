library(tidyverse)
library(readxl)

path = "Excel/089 Odd Number of Times.xlsx"
input = read_excel(path, range = "A1:A7")
test  = read_excel(path, range = "B1:B7") %>%
  na.omit() 

result = input %>%
  mutate(rn = row_number()) %>%
  separate_rows(Numbers, sep = ", ") %>%
  summarise(n = n(), .by = c(rn, Numbers)) %>%
  filter(n %% 2 == 1) %>%
  summarise(`Answer Expected` = paste(sort(as.numeric(Numbers)), collapse = ", "), .by = rn)

all.equal(result$`Answer Expected`, test$`Answer Expected`)
#> [1] TRUE