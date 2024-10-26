library(tidyverse)
library(readxl)

path = "Excel/157 Networkdays_2.xlsx"
input = read_excel(path, range = "A1:E8")
test  = read_excel(path, range = "F1:F8")

input2 = input %>%
  mutate(To = as.Date(To), From = as.Date(From)) %>%
  mutate(To = ifelse(is.na(To), today(), To) %>% as.Date(),
         Weekend = ifelse(is.na(Weekend), "Sat, Sun", Weekend)) %>%
  mutate(Weekend = strsplit(Weekend, ", ") %>% map_chr(~paste(., collapse = "|"))) %>%
  rowwise() %>%
  mutate(Dates = list(seq(From, To, by = "days"))) %>%
  unnest(Dates) %>%
  mutate(wday = wday(Dates, locale = "us", label = TRUE, abbr = TRUE)) %>%
  mutate(nday = str_detect(wday, pattern = Weekend)) %>%
  ungroup() %>%
  summarise(Workdays = sum(!nday), .by = Emp)
