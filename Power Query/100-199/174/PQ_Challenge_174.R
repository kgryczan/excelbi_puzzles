library(tidyverse)
library(readxl)
library(padr)

input = read_excel("Power Query/PQ_Challenge_174.xlsx", range = "A1:D5")
test  = read_excel("Power Query/PQ_Challenge_174.xlsx", range = "F1:J20")

result = input %>%
  pivot_longer(cols = -c(1, 4), names_to = "date", values_to = "value") %>%
  select(-date) %>%
  group_by(Emp) %>%
  pad() %>%
  fill(Sales, .direction = "down") %>%
  mutate(days = n(),
         daily_sales = Sales / days,
         month = floor_date(value, "month"),
         year = year(value)) %>%
  ungroup() %>%
  summarise(`Monthly Sales` = sum(daily_sales), 
            `From Date` = min(value),
            `To Date` = max(value), 
            .by = c("Emp", "month", "year")) %>%
  mutate(`Running Total` = cumsum(`Monthly Sales`), .by = c("Emp", "year")) %>%
  select(Emp, `From Date`, `To Date`, `Monthly Sales`, `Running Total`) %>%
  mutate(across(c(4:5), ~round(., digits = 2)))

# not all results match because of floaring point precision
# structure achieved
