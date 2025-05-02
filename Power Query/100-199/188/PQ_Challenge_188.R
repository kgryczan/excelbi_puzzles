library(tidyverse)
library(readxl)

input = read_excel("Power Query/PQ_Challenge_188.xlsx", range = "A1:D4")
test  = read_excel("Power Query/PQ_Challenge_188.xlsx", range = "F1:H11")

result = input %>%
  mutate(date = map2(`From Date`, `To Date`, seq, by = "day"), 
         days = map_int(date, length),
         daily = Amount / days) %>%
  unnest(date) %>%
  mutate(quarter = quarter(date), 
         year = year(date) %>% as.character() %>% str_sub(3, 4),
         Quarter = paste0("Q",quarter,"-",year)) %>%
  summarise(Amount = sum(daily) %>% round(0), .by = c(Store, Quarter))

identical(result, test)
# [1] TRUE