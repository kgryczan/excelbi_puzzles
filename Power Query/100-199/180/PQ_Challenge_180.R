library(tidyverse)
library(readxl)

input = read_excel("Power Query/PQ_Challenge_180.xlsx", range = "A1:B28")
test  = read_excel("Power Query/PQ_Challenge_180.xlsx", range = "D1:G4")

result = input %>%
  mutate(Emp = ifelse(is.na(Sales), `Emp-Month`, NA_character_)) %>%
  fill(Emp) %>%
  filter(!is.na(Sales)) %>%
  mutate(lag_sales = lag(Sales, 1, default = 0),
         lag_month = lag(`Emp-Month`, 1, default = ""),
         total = sum(Sales), 
         change = abs(lag_sales - Sales),
         max_change = max(change),
         .by = Emp) %>%
  filter(change == max_change) %>%
  select(Emp, `Total Sales` = total, `Max Sales Change` = max_change, lag_month, `Emp-Month`) %>%
  unite("From - To Months", lag_month, `Emp-Month`, sep = " - ")

identical(result, test)
# [1] TRUE