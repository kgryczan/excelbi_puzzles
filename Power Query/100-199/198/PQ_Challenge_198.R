library(readxl)
library(tidyverse)

path  = "Power Query/PQ_Challenge_198.xlsx"

input = read_excel(path, range = "A1:B20")
test  = read_excel(path, range = "D1:F20")

result = input %>%
  mutate(month = month(Date)) %>%
  summarise(Max = max(Value), .by = month) %>%
  mutate(`Running Total` = cumsum(Max)) %>%
  right_join(input %>% mutate(month = month(Date)), by = "month") %>%
  select(Date, Value, `Running Total`)

identical(result, test)
# [1] TRUE