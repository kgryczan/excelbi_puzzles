library(tidyverse)
library(readxl)

path = "Excel/700-799/743/743 Amount Distribution.xlsx"
input = read_excel(path, range = "A2:C7")
test  = read_excel(path, range = "E2:Q7") %>%
  arrange(Name)

calendar = expand.grid(
  Name = input$Name,
  Month = factor(month.abb, levels = month.abb, ordered = TRUE, labels = month.abb)
)

result = input %>%
  separate_longer_delim(Months, delim = ", ") %>%
  mutate(Month= month(as.numeric(Months), label = TRUE, abbr = TRUE, locale = "en_US.UTF-8")) 

r2 = result %>%
  full_join(calendar, by = c("Name", "Month")) %>%
  arrange(Name, Month) %>%
  mutate(non_zero_months = sum(ifelse(is.na(Amount), 0, 1)), 
         per_month_amount = ifelse(is.na(Amount), 0, Amount / non_zero_months),
         .by = Name) %>%
  select(Name, per_month_amount, Month) %>%
  pivot_wider(names_from = Month, values_from = per_month_amount)

all.equal(r2, test, check.attributes = FALSE)
# [1] TRUE
