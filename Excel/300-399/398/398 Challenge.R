library(tidyverse)
library(readxl)

input = read_excel("Excel/398 Min and Max Dates.xlsx", range = "A1:A25") %>% 
  mutate(Date = as.Date(Date))
test  = read_excel("Excel/398 Min and Max Dates.xlsx", range = "C2:F16") %>%
  mutate(`Min Date` = as.Date(`Min Date`), 
         `Max Date` = as.Date(`Max Date`))

seq = seq.Date(from = floor_date(min(input$Date), "month"), 
               to = floor_date(max(input$Date), "month")+1, 
               by = "month") %>%
  data.frame(date = .) %>%
  mutate(month = month(date), 
         year = year(date))

res = input %>%
  mutate(month = month(Date), 
         year = year(Date)) %>%
  left_join(seq, by = c("year", "month")) %>%
  group_by(date, month, year) %>%
  summarise(min = min(Date), 
            max = max(Date)) %>%
  ungroup() %>%
  select(Year = year, Month = month, `Min Date` = min, `Max Date` = max)

identical(res, test)
# [1] TRUE

