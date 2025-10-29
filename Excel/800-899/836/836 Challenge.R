library(tidyverse)
library(readxl)

path = "Excel/800-899/836/836 Index and Running Total.xlsx"
input = read_excel(path, range = "A2:A21")
test  = read_excel(path, range = "C2:D21")

result = input %>%
  mutate(`Group Index` = replace(cumsum(is.na(Data)) + 1, is.na(Data), NA)) %>%
  mutate(`Running Sum` = cumsum(Data), .by = `Group Index`) %>%
  select(-Data)

all.equal(result, test)
