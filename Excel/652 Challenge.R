library(tidyverse)
library(readxl)

path = "Excel/652 Generate Ticket Numbers.xlsx"
input = read_excel(path, range = "A1:B7")
test  = read_excel(path, range = "C1:C12")

result = input %>%
  separate_rows(Sequence, sep = ", ") %>%
  na.omit() %>%
  mutate(rn = row_number(), .by = Booklet) %>%
  arrange(rn, Booklet) %>%
  select(-rn) %>%
  unite(`Answer Expected`, Booklet, Sequence, sep = "")

all.equal(result, test)
#> [1] TRUE