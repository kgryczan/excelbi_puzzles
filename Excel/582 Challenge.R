library(tidyverse)
library(readxl)

path = "Excel/582 Pivot on Min and Max_2.xlsx"
input = read_excel(path, range = "A1:C26")
test  = read_excel(path, range = "E1:G7")

result = input %>%
  summarize(`Emp ID` = paste(sort(`Emp ID`), collapse = ", "), .by = c("Date", "Time")) %>%
  mutate(min = min(Time), max = max(Time), .by = "Date") %>%
  filter(Time %in% c(min, max)) %>% 
  select(-min, -max) %>%
  arrange(Date, Time)

all.equal(result, test)
#> [1] TRUE