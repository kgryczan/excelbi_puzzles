library(tidyverse)
library(readxl)

path <- "Excel/800-899/857/857 Tiered Commission.xlsx"
input <- read_excel(path, range = "A2:A62", col_names = FALSE)
test <- read_excel(path, range = "C2:D13")

tier_commisions = function(amount) {
  case_when(
    amount <= 50000 ~ 0.05 * amount,
    amount <= 100000 ~ 2500 + 0.07 * (amount - 50000),
    amount <= 200000 ~ 6000 + 0.10 * (amount - 100000),
    TRUE ~ 16000 + 0.15 * (amount - 200000)
  )
}

result = input %>%
  separate_wider_delim(cols = 1, delim = ",", names_sep = "_") %>%
  janitor::row_to_names(1) %>%
  select(Salesperson, Month, `Total Sales`) %>%
  mutate(Comission = tier_commisions(as.numeric(`Total Sales`))) %>%
  summarise(Total_Commission = sum(Comission), .by = Salesperson) %>%
  arrange(Salesperson) %>%
  janitor::adorn_totals("row", name = "Grand Total")

all.equal(result, test, check.attributes = FALSE)
# TRUE
