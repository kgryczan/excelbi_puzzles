library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_239.xlsx"
input = read_excel(path, range = "A1:E4")
test  = read_excel(path, range = "G1:J10")

result = input %>%
  pivot_longer(cols = -c(1), names_to = "quarter", values_to = "sales") %>%
  mutate(`QtQ Drop` = paste0(lead(quarter),"-",quarter),
         Amount = lead(sales) - sales,
         tot_amount = sum(Amount, na.rm = TRUE),
         .by = Name) %>%
  mutate(Rank = dense_rank(-tot_amount),
         Name = ifelse(quarter == "Q1", Name, NA),
         Rank = ifelse(quarter == "Q1", Rank, NA)) %>%
  filter(!is.na(Amount)) %>%
  select(Name, `QtQ Drop`, Amount, Rank)

all.equal(result, test, check.attributes = FALSE)

#> [1] TRUE