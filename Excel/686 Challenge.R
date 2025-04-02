library(tidyverse)
library(readxl)

path = "Excel/686 Data Alignment.xlsx"
input = read_excel(path, range = "A1:C23")
test  = read_excel(path, range = "E2:H8")

Sys.setlocale("LC_TIME", "English")

result = input %>%
  mutate(Role_no = cumsum(Role != lag(Role, default = first(Role)))+1, .by = EmpCode) %>%
  summarise(max_date = max(Date) %>% 
              format("%b%y"),
            min_date = min(Date) %>%
              format("%b%y"),
            .by = c(EmpCode, Role_no, Role)) %>%
  mutate(period = ifelse(max_date == min_date, min_date, paste0(min_date, " to ", max_date))) %>%
  select(EmpCode, Role, period) %>%
  pivot_wider(names_from = EmpCode, values_from = period, values_fn = ~paste(., collapse = ", ")) %>%
  select(Role, sort(names(.))) %>%
  arrange(Role)