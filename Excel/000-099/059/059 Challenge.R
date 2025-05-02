library(tidyverse)
library(readxl)

path = "Excel/059 No. of Workdays.xlsx"
test  = read_excel(path, range = "C1:C5")
years = 2000:2099
holiday = c("01.01", "04.07", "11.11", "25.12")

holidays = map(years, ~paste0(holiday,".",.x)) %>%
  unlist() %>%
  dmy()

all_days = seq(as.Date("2000-01-01"), as.Date("2099-12-31"), by = "1 day") %>% 
  data.frame(date = .) %>%
  mutate(wday = wday(date, week_start = 1),
         year = year(date)) %>%
  filter(!date %in% holidays,
         wday %in% 1:5) %>%
  summarise(n = n(), .by = year) %>%
  slice_max(n, n = 1) 

identical(test$`Answer Expected`, all_days$year)
#> [1] TRUE