library(tidyverse)
library(readxl)

path = "Excel/700-799/709/709 Filter Out Repeats.xlsx"
input = read_excel(path, range = "A2:B10")
test = read_excel(path, range = "C2:D8")

result = input %>%
  filter(!(n_distinct(str_extract_all(Data2, "[A-Z]")[[1]]) == 1 & 
           str_length(Data2) != 1 & 
           n() != 1), .by = Data2) %>%
  select(Data1, Data2)

all.equal(result, test)
# TRUE
