library(tidyverse)
library(readxl)

path = "Power Query/300-399/328/PQ_Challenge_328.xlsx"
input = read_excel(path, range = "A1:K5", .name_repair = "minimal")
test  = read_excel(path, range = "A9:D18")

result = input %>%
  pivot_longer(-c(1,2), names_to = c(".value", "transaction"),
               names_pattern = "(Credit|Debit|Date)(\\d?)") %>%
  filter(!is.na(Date)) %>%
  mutate(across(c(Debit, Credit), ~replace_na(., 0))) %>%
  group_by(Cust) %>%
  mutate(transaction = row_number(),
         Closing = `Opening Balance` + cumsum(Credit - Debit),
         Opening = ifelse(transaction == 1, `Opening Balance`, lag(Closing))) %>%
  select(Cust, Date, `Opening Balance` = Opening, `Closing Balance` = Closing) %>%
  ungroup()

all.equal(result, test)
# [1] TRUE