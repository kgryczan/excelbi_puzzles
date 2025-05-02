library(tidyverse)
library(readxl)

path = "Excel/225 Kangaroo Words.xlsx"
input = read_excel(path, range = "A1:A2283")
test = read_excel(path, range = "B2:C65")

all = crossing(first = input$Words, second = input$Words)

res = all %>%
  filter(first != second) %>%
  rowwise() %>%
  mutate(is_kangaroo = str_detect(first, second))

res1 = res %>%
  filter(is_kangaroo)

res2 = res1 %>%
  ungroup() %>%
  mutate(n = n(), .by = first) %>%
  filter(n > 1) %>%
  summarise(second = paste(sort(unique(second)), collapse = ", "), .by = first)
