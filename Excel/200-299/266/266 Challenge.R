library(tidyverse)
library(readxl)

path = "Excel/200-299/266/266 Odd Odd Times Even Even Times.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B6")

result = input %>%
  mutate(digs = str_split(Number, pattern = "")) %>%
  unnest(digs) %>%
  summarise(n = n(), .by = c(Number, digs)) %>%
  mutate(even_even = n %% 2 == 0 & as.numeric(digs) %% 2 == 0, 
         odd_odd = n %% 2 == 1 & as.numeric(digs) %% 2 == 1) %>%
  mutate(max = even_even + odd_odd) %>%
  summarise(min = min(max, na.rm = TRUE),
            .by = Number) %>%
  filter(min > 0) %>%
  select(Number) 

all.equal(result$Number, test$`Answer Expected`, check.attributes = FALSE)
# > [1] TRUE