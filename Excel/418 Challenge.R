library(tidyverse)
library(readxl)
library(hms)

input = read_excel("Excel/418 Pivot on Min and Max .xlsx", range = "A1:C26")
test  = read_excel("Excel/418 Pivot on Min and Max .xlsx", range = "E1:G13") %>%
  mutate(`Min & Max Time` = as_hms(`Min & Max Time`))

result = input %>%
  summarise(Min = min(Time), Max = max(Time), .by = c(Date, `Emp ID`)) %>%
  pivot_longer(cols = c(Min, Max), names_to = "Type", values_to = "Time") %>%
  mutate(`Min & Max Time` = as_hms(Time)) %>%
  select(-c(Type, Time)) %>%
  arrange(Date, `Emp ID`)
  
identical(result, test)
# [1] TRUE
