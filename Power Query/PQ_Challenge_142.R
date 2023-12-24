library(tidyverse)
library(readxl)
library(lubridate)

input = read_excel("Power Query/PQ_Challenge_142.xlsx", range = "A1:C4") 
  %>% janitor::clean_names()
test = read_excel("Power Query/PQ_Challenge_142.xlsx", range = "E1:F49")

input <- input %>%
  mutate(interval = interval(ymd_hms(start_time), ymd_hms(end_time)))

quarter_table <- tibble(
  interval = interval(
    seq(ymd_hms("1899-12-31 09:00:00"), 
        ymd_hms("1899-12-31 20:45:00"), 
        by = "15 mins"),
    seq(ymd_hms("1899-12-31 09:14:59"), 
        ymd_hms("1899-12-31 20:59:59"), 
        by = "15 mins")
  )
)
head_count <- quarter_table %>%
  mutate(
    Count = map_dbl(interval, ~sum(int_overlaps(.x, input$interval))),
    Time = paste(format(int_start(interval), "%I:%M:%S %p"), 
                 format(int_end(interval), "%I:%M:%S %p"), 
                 sep = " - ")
  ) %>%
  select(Time, Count)
