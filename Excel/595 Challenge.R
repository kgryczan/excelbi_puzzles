library(tidyverse)
library(readxl) 
library(janitor)

path = "Excel/595 List Weekdays Saturdays and Sundays and Total.xlsx"
input = read_excel(path, range = "A1:B4")
test  = read_excel(path, range = "D1:G13")


result = input %>% 
  mutate(start_of_month = make_date(Year, Month, 1),
         end_of_month = make_date(Year, Month, 1) %>% ceiling_date("month") - 1) %>%
  mutate(seq = map2(start_of_month, end_of_month, seq, by = "days")) %>%
  unnest(seq) %>%
  mutate(Type = wday(seq, label = T, locale = "en", abbr = F),
         Type = case_when(Type == "Sunday" ~ "Sundays",
                          Type == "Saturday" ~ "Saturdays",
                            TRUE ~ "Weekdays") %>% factor(., levels = c("Weekdays", "Saturdays", "Sundays"), ordered = T)) %>%
  summarise(Days = n(), .by = c(Year, Month, Type)) %>%
  arrange(Year, Month, Type) %>%
  group_by(Year, Month) %>%
  group_modify(~ .x %>% adorn_totals("row")) %>%
  ungroup() %>%
  mutate(Year = ifelse(Type == "Total", "Total:", Year),
         Month = ifelse(Type == "Total", NA, Month),
         Type = ifelse(Type == "Total", NA, as.character(Type)))

all.equal(result, test, check.attributes = F)
#> [1] TRUE