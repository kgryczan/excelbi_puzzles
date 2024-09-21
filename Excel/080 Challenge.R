library(tidyverse)
library(readxl)

path = "Excel/080 First, Third and Fifth Saturdays.xlsx"
input = read_excel(path, range = "A1", col_names = FALSE) %>% pull()
test  = read_excel(path, range = "A2:A30", col_names = "date") %>% mutate(date = as.Date(date))

dates = seq(from = make_date(input, 1,1), to = make_date(input, 12,31), by = "days") %>%
  as_tibble() %>%
  mutate(weekday = wday(value, week_start = 1),
         month = month(value)) %>%
  filter(weekday == 6) %>%
  mutate(rn = row_number(), .by = month) %>%
  filter(rn %% 2 == 1) %>%
  select(value)

all.equal(dates$value,test$date, check.attributes = FALSE)
#> [1] TRUE