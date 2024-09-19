library(tidyverse)
library(readxl)

path = "Excel/056 Second and Fourth Saturday.xlsx"
input = read_excel(path, range = "A1", col_names = F) %>% pull()
test  = read_excel(path, range = "A2:A7", col_names = "dates") %>% pull() %>% as.Date()

parse_quarter = function(input) {
  start = fast_strptime(input, format = "Q%q-%Y") %>% as.Date()
  end = (start + months(3) - days(1)) %>% as.Date()
  
  return(data.frame(start = start, end = end))
}

a = parse_quarter("Q1-2022")
dates = seq.Date(a$start, a$end, by = "day") %>% 
  data.frame(date = .) %>%
  mutate(wday = wday(date, week_start = 1),
         month = month(date)) %>%
  filter(wday == 6) %>%
  mutate(week = week(date) - week(date[1]) + 1) %>%
  mutate(rn = row_number(), .by = month) %>%
  filter(rn %in% c(2, 4)) %>%
  select(date) %>% pull()

identical(dates, test)
#> [1] TRUE