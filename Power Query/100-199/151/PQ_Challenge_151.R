library(tidyverse)
library(readxl)
library(hms)

test  = read_excel("Power Query/PQ_Challenge_151.xlsx", range = "G1:H6") %>%
  janitor::clean_names()


read_excel_range <- function(file, range) {
  read_excel(file, range = range) %>%
    mutate(across(c(starts_with("Start Time"), starts_with("End Time")), as_hms),
           across(c(starts_with("Start Date"), starts_with("End Date")), as_date)) %>%
    janitor::clean_names()
}

input1 <- read_excel_range("Power Query/PQ_Challenge_151.xlsx", "A1:E6")
input2 <- read_excel_range("Power Query/PQ_Challenge_151.xlsx", "A9:D14")

result <- input1 %>%
  mutate(
    start = as_datetime(start_date) + start_time,
    end = as_datetime(end_date) + end_time,
    datetime = map2(start, end, seq, by = "hour")
  ) %>%
  unnest(datetime) %>%
  mutate(
    weekday = wday(datetime, week_start = 1),
    time = as_hms(datetime)
  ) %>%
  left_join(input2, by = "weekday") %>%
  filter(datetime >= start & datetime <= end, 
         time >= start_time.y & time < end_time.y) %>%
  group_by(employee) %>%
  summarise(total_hours = n() %>% as.numeric())

identical(result, test)
#> [1] TRUE