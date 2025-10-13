library(tidyverse)
library(readxl)

path = "Excel/800-899/824/824 Group By Consecutive Dates.xlsx"
input = read_excel(path, range = "A2:B15")
test  = read_excel(path, range = "D2:E6")

result = input %>%
  mutate(Dates = ymd(Dates)) %>%
  mutate(group = cumsum(Dates - lag(Dates, default = first(Dates)) > 1)) %>%
  summarise(`Date Range` = ifelse(min(Dates) == max(Dates), 
                                  as.character(min(Dates)), 
                                  paste(min(Dates), max(Dates), sep = " To ")),
            Total = sum(Value, na.rm = T), .by = group) %>%
  select(-group)

all.equal(result, test)
# [1] TRUE