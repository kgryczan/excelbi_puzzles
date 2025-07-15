library(tidyverse)
library(readxl)

path = "Excel/200-299/265/265 Isogram Dates.xlsx"
Count = read_excel(path, range = "B2:B2", col_names = FALSE) %>% pull()
Min_Date = read_excel(path, range = "B3:B3", col_names = FALSE) %>% pull()
Max_Date = read_excel(path, range = "B4:B4", col_names = FALSE) %>% pull()

# seq date from 2001-01-01 to 2099-12-31

Dates = seq(as.Date("2001-01-01"), as.Date("2099-12-31"), by = "day") %>%
  as_tibble() %>%
  mutate(value = as.character(value)) %>%
  separate(value, into = c("Year", "Month", "Day"), sep = "-", remove = F) %>%
  mutate(Year = str_sub(Year, 3,4)) %>%
  mutate(Date = paste0(Year, Month, Day)) %>%
  mutate(Date = str_split(Date, "")) %>%
  mutate(Count = map_int(Date, ~ length(unique(.)))) %>%
  filter(Count == 6)

Count == nrow(Dates) # > TRUE
Min_Date == min(Dates$value) # > TRUE
Max_Date == max(Dates$value) # > TRUE
