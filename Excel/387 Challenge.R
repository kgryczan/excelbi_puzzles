library(tidyverse)
library(readxl)

test = read_excel("Excel/387 Fill in the Last Dates.xlsx", range = "B1:H6") %>%
  mutate(across(everything(), as.Date))

date = read_excel("Excel/387 Fill in the Last Dates.xlsx", range = "A1", col_names = FALSE) %>%
  pull()

df = data.frame(date = seq(floor_date(date, "month"), 
                           ceiling_date(date, "month") - days(1), 
                           by = "day") %>%
                  as.Date()) %>%
  mutate(week = week(date), 
         wday = wday(date, label = T, abbr = T,  week_start = 1, locale = "US_us")) %>%
  pivot_wider(names_from = wday, values_from = date) %>%
  select(week, Mon, Tue, Wed, Thu, Fri, Sat, Sun) %>%
  arrange(desc(week)) %>%
  select(-week)

identical(df, test)
# [1] TRUE
