library(tidyverse)
library(readxl)

path = "Excel/703 Max_Total_By_Days.xlsx.xlsx"
input = read_excel(path, range = "A1:C31")
test = read_excel(path, range = "E2:F6") %>% arrange(Names)

result = input %>%
  mutate(consecutive_id = cumsum(c(1, diff(Date) > 1)), .by = Names) %>%
  summarise(Quantity = sum(Quantity), .by = c("Names", "consecutive_id")) %>%
  filter(Quantity == max(Quantity), .by = Names) %>%
  select(-consecutive_id) %>%
  arrange(Names)

all.equal(result, test)
#> [1] TRUE
