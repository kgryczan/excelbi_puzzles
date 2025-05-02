library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_210.xlsx"
input = read_xlsx(path, range = "A1:C17")
test  = read_xlsx(path, range = "E1:H10")

r1 = input %>%
  select(Name, Date) %>%
  group_by(Name) %>%
  summarise(Date = list(seq(min(Date), max(Date), by = "day"))) %>%
  unnest(Date) %>%
  left_join(input, by = c("Name", "Date")) %>%
  mutate(wday = wday(Date, week_start = 1),
         Type = case_when(
           wday == 6 ~ lag(Type, 1),
           wday == 7 ~ lag(Type, 2),
           TRUE ~ Type
         )) %>%
  mutate(cons = consecutive_id(Type), .by = "Name") %>%
  filter(!is.na(Type), 
         wday %in% 1:5) %>%
  summarise(`From Date` = min(Date), 
            `To Date` = max(Date), 
            .by = c(Name, Type, cons)) %>%
  select(Name, `From Date`, `To Date`, Type) %>%
  arrange(desc(Name))

identical(r1, test)
# [1] TRUE
