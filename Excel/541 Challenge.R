library(tidyverse)
library(readxl)

path = 'Excel/541 Months Having 5 Fri Sat Sun.xlsx'
test = read_xlsx(path)

years  = 2000:2999
months = 1:12

dates = expand.grid(year = years, month = months) %>%
  mutate(diy = days_in_month(make_date(year, month)),
         wday = wday(make_date(year, month, 1), label = TRUE, locale = 'en'),
         month_abbr = month(make_date(year, month, 1), label = TRUE, locale = "en"), 
         date = paste0(month_abbr,"-",year)) %>%
  filter(diy == 31, wday == "Fri") %>%
  summarise(`Expected Answer` = paste(date, collapse = ", "), .by = year) %>%
  arrange(year) %>%
  select(-year)

all.equal(test, dates, check.attributes = FALSE)
#> [1] TRUE