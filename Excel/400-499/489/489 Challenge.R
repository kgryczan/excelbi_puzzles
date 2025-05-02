library(tidyverse)
library(readxl)
library(hms)

path = "Excel/489 Total Time in a Week.xlsx"
input = read_excel(path, range = "A2:H6")
test  = read_excel(path, range = "J2:K6")

result = input %>%
  pivot_longer(-c(`Time Period`), names_to = "wday", values_to = "Name") %>%
  separate(`Time Period`, into = c("start", "end"), sep = " - ") %>%
  mutate(across(c(start, end), ~as_hms(parse_time(.)))) %>%
  mutate(duration = difftime(end, start, units = "hours") %>% as.numeric()) %>%
  na.omit() %>%
  summarise(`Total Hours` = sum(duration), .by = Name)

identical(result, test)
# [1] TRUE