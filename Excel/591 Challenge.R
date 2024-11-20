library(tidyverse)
library(readxl)

path = "Excel/591 Sum of Numbers following Hashes.xlsx"
input = read_excel(path, range = "A1:A20")
test  = read_excel(path, range = "B1:B20")

result = input %>%
  mutate(group = cumsum(Data == "#")) %>%
  mutate(`Answer Expected` = ifelse(Data == "#", 
                                    sum(as.numeric(Data), na.rm = TRUE), 
                                    as.numeric(Data)), .by = group)

all.equal(result$`Answer Expected`, test$`Answer Expected`)
#> [1] TRUE