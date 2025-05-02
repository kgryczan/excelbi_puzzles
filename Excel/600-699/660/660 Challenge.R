library(tidyverse)
library(readxl)

path = "Excel/660 Insert Sum After Year Ends.xlsx"
input = read_excel(path, range = "A2:B13")
test  = read_excel(path, range = "D2:E16")

result = input %>%
  separate(`Year-Quarter`, into = c("Year-Quarter", "Quarter"), sep = "-") %>%
  summarise(Amount = sum(Amount), .by = `Year-Quarter`) %>%
  mutate(`Year-Quarter` = paste0(`Year-Quarter`, "-Q5")) %>%
  bind_rows(input) %>%
  arrange(`Year-Quarter`) %>%
  mutate(`Year-Quarter` = ifelse(str_detect(`Year-Quarter`, "Q5"), NA, `Year-Quarter`))

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE
