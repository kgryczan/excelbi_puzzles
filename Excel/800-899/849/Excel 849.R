library(tidyverse)
library(readxl)

path <- "Excel/800-899/849/849 Running Total.xlsx"
input <- read_excel(path, range = "A1:A20")
test  <- read_excel(path, range = "B1:B20")

result = input %>%
  mutate(seq = map_int(row_number(), ~ min(which(cumsum(1:.) >= .)))) %>%
  mutate(cumsum = cumsum(Data), .by = seq) %>%
  select(`Answer Expected` = cumsum)

all.equal(result, test)
# [1] TRUE