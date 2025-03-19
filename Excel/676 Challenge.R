library(tidyverse)
library(readxl)

path = "Excel/676 Credit card payment amount.xlsx"
input = read_excel(path, range = "A1:B101")
test  = read_excel(path, range = "E1:G14")

result <- input %>%
  mutate(Date = as.Date(Date)) %>%
  mutate(adjusted_date = ifelse(day(Date) >= 26, Date + days(6), Date) %>% as.Date(origin = "1970-01-01")) %>%
  filter(year(adjusted_date) == 2025) %>%
  mutate(Quarter = paste0("Q", quarter(adjusted_date)),
         Month = month(adjusted_date, label = TRUE, abbr = TRUE, locale = "en")) %>%
  summarise(Payment = sum(Payment, na.rm = TRUE), .by = c("Quarter", "Month")) 

total = result %>%
  summarise(Payment = sum(Payment, na.rm = TRUE)) %>%
  mutate(Quarter = "Total", Month = NA) %>%
  relocate(Quarter, Month, Payment)

result = bind_rows(result, total)

