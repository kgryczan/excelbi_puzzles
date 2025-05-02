library(tidyverse)
library(readxl)

path = "Excel/052 Last Monday.xlsx"
input = read_excel(path, range = "A1", col_names = FALSE) %>% pull()
test  = read_excel(path, range = "A2:A11", col_names = "Date") 

last_mondays = function(year){
  dates = seq(as.Date(paste0(year, "-01-01")), as.Date(paste0(year, "-12-31")), by = "days")
  dates = tibble(Date = dates) %>%
    mutate(day = day(Date),
           wday = wday(Date),
           month = month(Date)) %>%
  filter(wday == 2 & day > 25) %>%
  mutate(Date = as.POSIXct(Date)) %>%
  select(Date) 
  return(dates)
}

identical(test, last_mondays(input))
#> [1] TRUE