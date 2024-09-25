library(tidyverse)
library(readxl)

path = "Excel/105 Christmas.xlsx"
input = read_excel(path, range = "A1:A1", col_names = F) %>% pull()
test  = read_excel(path, range = "A2:B9")

year_start = year(today())-input
year_end = year(today())

values = data.frame(date = make_date(year_start:year_end, 12L, 24L)) %>%
  mutate(DAY = wday(date, label = T, abbr = T, locale = "en", week_start = 1)) %>%
  summarise(COUNT = n(), .by = DAY)

values
