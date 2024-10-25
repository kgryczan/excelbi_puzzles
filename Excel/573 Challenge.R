library(tidyverse)
library(readxl)
library(hms)
library(janitor)
library(lubridate)

path = "Excel/573 Durations.xlsx"
input = read_excel(path, range = "A2:B14")
test  = read_excel(path, range = "D2:E6")

result = input %>%
  mutate(name = ifelse(str_detect(`Name & Date`, "[a-zA-Z]"), `Name & Date`, NA)) %>%
  fill(name) %>%
  filter(!is.na(Time)) %>% 
  mutate(date =  excel_numeric_to_date(as.numeric(`Name & Date`)) %>% as.character(),
         time = as_hms(Time) %>% as.character()) %>%
  unite("datetime", c("date", "time"), sep = " ") %>%
  mutate(datetime = ymd_hms(datetime)) %>%
  select(name, datetime) %>%
  mutate(rn = row_number(), .by = name) %>%
  pivot_wider(names_from = rn, values_from = datetime) %>%
  mutate(duration = as.numeric(`2` - `1`)) %>%
  select(Name = name, Duration = duration)

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE