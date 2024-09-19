library(tidyverse)
library(readxl)

path = "Excel/069 Champion Continuous.xlsx"
input = read_excel(path, range = "A1:B22")
test  = read_excel(path, range = "C2:D5")

result = input %>%
  mutate(gr = consecutive_id(Champion)) %>%
  filter(n() > 1, .by = gr) %>%
  summarise(Champion = first(Champion), 
            `Times Won` = str_c(Year, collapse = ", "), 
            .by = gr) %>%
  select(-gr)

identical(result, test)
#> [1] TRUE