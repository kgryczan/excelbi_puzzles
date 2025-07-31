library(tidyverse)
library(readxl)

path = "Excel/700-799/772/772 Split and Sum.xlsx"
input = read_excel(path, range = "A1:A14")
test  = read_excel(path, range = "B2:C5", col_names = c("Letter", "Value"))

result = input %>%
  separate_wider_delim(Data, delim = "-", names = c("Letter", "Number"), too_few = "align_start") %>%
  na.omit() %>%
  summarise(Value = sum(as.numeric(Number), na.rm = T), .by = Letter) 

all.equal(result, test)
# mistake in given solution