library(tidyverse)
library(readxl)

path = "Excel/070 FIFA WC Winners.xlsx"
input = read_excel(path, range = "A1:B22")
test  = read_excel(path, range = "C2:D9")

result = input %>%
  arrange(Champion) %>%
  mutate(id = cumsum(c(1, diff(Year)) > 20), .by = Champion) %>%
  mutate(gr = n(), .by = c(Champion, id)) %>%
  filter(gr >= 2) %>%
  summarise(Champion = first(Champion), 
            Year = str_c(Year, collapse = ", "), 
            .by = c(Champion, id)) %>%
  select(Champion, Year) %>%
  arrange(Year)

identical(result, test)
# [1] TRUE