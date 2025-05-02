library(tidyverse)
library(readxl)

path = "Excel/498 Soccer Champions Alignment.xlsx"
input = read_xlsx(path, range = "A2:B10")
test = read_xlsx(path, range = "D2:E24")

result = input %>%
  separate_rows(Years, sep = ",") %>%
  mutate(Years = as.numeric(Years)) %>%
  arrange(desc(Years)) %>%
  select(Year = Years, Winner = Winners)

identical(result, test)
# [1] TRUE