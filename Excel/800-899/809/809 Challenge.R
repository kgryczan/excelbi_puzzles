library(tidyverse)
library(readxl)
library(rebus)

path = "Excel/800-899/809/809 Extract DOB Age Height.xlsx"
input = read_excel(path, range = "A2:A10")
test  = read_excel(path, range = "B2:D10") %>%
  arrange(Age)

date_pattern = "[0-9]{1,2}(?:st|nd|rd|th)? [[:alpha:]]+ [0-9]{4}|[0-9]{1,2}/[0-9]{1,2}/[0-9]{2,4}|[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}"
age_pattern = "(?<=^| )[0-9]{1,2}(?:\\.[0-9]{1,2})?(?= |\\.|$)"
height_pattern = "[0-9]{1,2}'[0-9]{1,2}\""

result = input %>% 
  mutate(DOB = str_extract_all(String, date_pattern)) %>%
  unnest(DOB, keep_empty = TRUE) %>%
  mutate(DOB = parse_date_time(DOB, orders = c("dmy", "mdy", "ymd"))) %>%
  group_by(String) %>%
  arrange(DOB, .by_group = T) %>%
  distinct(String, .keep_all = TRUE) %>%
  ungroup() %>%
  mutate(Age = str_extract(String, age_pattern) %>% as.integer()) %>%
  mutate(Height = str_extract(String, height_pattern)) %>%
  select(`Date of Birth` = DOB, Age, Height) %>%
  arrange(Age)

all.equal(result, test, check.attributes = FALSE)
# different values :(
          
          