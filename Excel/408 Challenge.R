library(tidyverse)
library(readxl)

input = read_excel("Excel/408 Angle Between Hour and Minute Hands.xlsx", range = "A1:A10") 
test  = read_excel("Excel/408 Angle Between Hour and Minute Hands.xlsx", range = "B1:B10")

angle_per_min_hh = 360/(60*12)
angle_per_min_mh = 360/60

result = input %>%
  mutate(time = as.character(Time),
         Time = str_extract(time, "\\s\\d{2}:\\d{2}")) %>%
  separate(Time, into = c("hour","mins"), sep = ":") %>%
  mutate(hour = as.numeric(hour),
         mins = as.numeric(mins), 
         hour12 = hour %% 12, 
         period_hh = hour12*60 + mins,
         period_mh = mins,
         angle_hh = period_hh * angle_per_min_hh,
         angle_mh = period_mh * angle_per_min_mh,
         angle_hh_to_mh = if_else(angle_hh > angle_mh, 
                                  360 - (angle_hh - angle_mh), 
                                  angle_mh - angle_hh)) %>%
  select(answer_expected = angle_hh_to_mh)

identical(result$answer_expected, test$`Answer Expected`)
# [1] TRUE
