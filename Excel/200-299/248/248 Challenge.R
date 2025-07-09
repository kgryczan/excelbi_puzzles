library(tidyverse)
library(readxl)

path = "Excel/200-299/248/248 Month Quarter Printing.xlsx"
input = read_excel(path, range = "A1:A7")
test  = read_excel(path, range = "B1:B7") %>% na.omit()

result = input %>%
  mutate(across(everything(), as.character),
         pos = str_locate_all(String, "1")) %>%
  unnest(pos) %>%
  mutate(quarter = ceiling(pos[, 1] / 3),
         date = paste0(format(make_date(2025L, pos[, 1], 1), "%b"), "-Q", quarter)) %>%
  summarise(months = paste(date, collapse = ", "), .by = String) 

all.equal(result$months, test$`Answer Expected`, check.attributes = FALSE) 
# > [1] TRUE