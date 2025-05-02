library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_258.xlsx"
input = read_excel(path, range = "A2:D7")
test  = read_excel(path, range = "A11:M16") %>%
  replace(is.na(.), 0)

r2 = input %>%
  mutate(year = 2025) %>%
  uncount(`Total Months`, .remove = F) %>%
  mutate(month_amount = Amout / `Total Months`) %>%
  mutate(`Start Month` = match(`Start Month`, month.abb)) %>%
  mutate(month = `Start Month` + row_number() - 1, .by = Name) %>%
  mutate(year = ifelse(month > 12, year + 1, year),
         month = ifelse(month > 12, month - 12, month)) %>%
  select(Name, year, month, month_amount) %>%
  mutate(month = month.abb[month])


r3 = expand.grid(year = 2025, month = month.abb, Name = unique(input$Name)) %>%
  left_join(r2, by = c("year", "month", "Name")) %>%
  pivot_wider(names_from = month, values_from = month_amount) %>%
  select(-year) %>%
  replace(is.na(.), 0)

all.equal(r3, test, check.attributes = F)
# [1] TRUE