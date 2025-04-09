library(tidyverse)
library(readxl)

path = "Excel/215 Total Spend.xlsx"
input1 = read_excel(path, range = "A1:D6")
input2 = read_excel(path, range = "F1:G4")
test  = read_excel(path, range = "H1:H4")

cal = input1 %>%
  mutate(From_Date = as.Date(`From Date`),
         To_Date = as.Date(`To Date`)) %>%
  rowwise() %>%
  mutate(Date = list(seq(From_Date, To_Date, by = "1 day"))) %>%
  unnest_longer(Date) %>%
  select(Date, Rate, `No of People`)

result = input2 %>%
  mutate(From_Date = as.Date(`From Date`),
         To_Date = as.Date(`To Date`)) %>%
  rowwise() %>%
  mutate(Date = list(seq(`From Date`, `To Date`, by = "1 day"))) %>%
  unnest_longer(Date) %>%
  left_join(cal, by = "Date") %>%
  mutate(Spend = Rate * `No of People`) %>%
  select(1,2,8) %>%
  summarise(Total_Spend = sum(Spend, na.rm = TRUE), .by = c(`From Date`, `To Date`)) 

all.equal(result$Total_Spend, test$`Total Spend`)
# [1] TRUE
