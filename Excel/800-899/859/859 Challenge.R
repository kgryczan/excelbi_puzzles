library(tidyverse)
library(readxl)

path <- "Excel/800-899/859/859 Extract Numbers and Align.xlsx"
input <- read_excel(path, range = "A1:B6")
test <- read_excel(path, range = "C1:C12")

result = input %>%
  separate_longer_delim(Data2, delim = ", ") %>%
  mutate(rn = row_number(), .by = Data1) %>%
  arrange(rn, Data1) %>%
  select(-rn) %>%
  na.omit() %>%
  unite("Answer Expected", Data1, Data2, sep = "")

all.equal(result$`Answer Expected`, test$`Answer Expected`)
