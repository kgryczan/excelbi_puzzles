library(tidyverse)
library(readxl)

path = "Excel/200-299/262/262 Multiplication Dates.xlsx"
test  = read_excel(path, range = "A1:A213")

dates = seq(as.Date("2000-01-01"), as.Date("2099-12-31"), by = "day") %>% 
  as.tibble() %>%
  mutate(value = as.character(value)) %>%
  separate(value, into = c("year", "month", "day"), sep = "-") %>%
  mutate(year = as.numeric(year) - 2000, 
         month = as.numeric(month),
         day = as.numeric(day)) %>%
  filter(year == month * day) %>%
  mutate(Dates = make_date(year + 2000, month, day) %>% as.character())

all.equal(dates$Dates, test$Dates, check.attributes = FALSE)
# > [1] TRUE