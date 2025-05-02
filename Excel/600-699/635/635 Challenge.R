library(tidyverse)
library(readxl)

path = "Excel/635 Sorting Years Month Days.xlsx"
input = read_excel(path, range = "A1:A8")
test  = read_excel(path, range = "C1:C8")

result = input %>%
  separate(col = DATA, sep = " ", into = c("Year","Y", "Month","M", "Day","D"), remove = F) %>%
  mutate(dur = dyears(as.numeric(Year)) + dmonths(as.numeric(Month)) + ddays(as.numeric(Day))) %>%
  arrange(dur) %>%
  select(DATA)

all.equal(result$DATA, test$`SORT DATA RESULTS`)
#> [1] TRUE
