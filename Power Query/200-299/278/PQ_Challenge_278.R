library(tidyverse)
library(readxl)
library(janitor)

path = "Power Query/PQ_Challenge_278.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "C1:I5") %>%
  mutate(across(-c(1), ~replace_na(as.numeric(.x), 0)))

result = input %>%
  separate(col = 1, into = c("Date", "Org", "Revenue", "Cost"), sep = " - ", extra = "merge",convert = TRUE) %>%
  mutate(profit = Revenue - Cost,
         month = month(mdy(Date), label = TRUE, abbr = TRUE, locale = "en_US.UTF-8"),
         month = factor(month, ordered = T, levels = c("Jan", "Feb", "Mar", "Apr", "May", "Jun")
         )) %>%
  select(-c(Revenue, Cost, Date)) %>%
  arrange(Org) %>%
  pivot_wider(names_from = month, values_from = profit, values_fn = sum, names_expand = TRUE)

res = result %>%
  add_row(Org = "Total", 
          `Jan` = sum(result$Jan, na.rm = TRUE),
          `Feb` = sum(result$Feb, na.rm = TRUE),
          `Mar` = sum(result$Mar, na.rm = TRUE),
          `Apr` = sum(result$Apr, na.rm = TRUE),
          `May` = sum(result$May, na.rm = TRUE),
          `Jun` = sum(result$Jun, na.rm = TRUE)) %>%
  mutate(across(-Org, ~replace_na(.x, 0)))

all.equal(res, test)
#> [1] TRUE