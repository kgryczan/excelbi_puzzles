library(tidyverse)
library(readxl)

path = "Excel/800-899/844/844 Currency Conversion.xlsx"
input = read_excel(path, range = "A2:B10")
test  = read_excel(path, range = "D2:M11")

input = input %>% add_row(Currency = "USD", Rate = 1)

result = tidyr::crossing(from = input$Currency, to = input$Currency) %>%
  left_join(input, by = c("from" = "Currency")) %>%
  left_join(input, by = c("to" = "Currency"), suffix = c(".from", ".to")) %>%
  mutate(rate = round(if_else(from == to, 1, Rate.to / Rate.from), 3)) %>%
  select(from, to, rate) %>%
  pivot_wider(names_from = to, values_from = rate, names_sort = TRUE) %>%
  rename(...1 = from)

all.equal(result, test)
# [1] TRUE
