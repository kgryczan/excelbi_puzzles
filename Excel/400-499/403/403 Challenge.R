library(tidyverse)
library(readxl)

input = read_excel("Excel/403 Generate Pivot Table.xlsx", range = "A1:B100")
test  = read_excel("Excel/403 Generate Pivot Table.xlsx", range = "D2:F9")

result = input %>%
  add_row(Year = 2024, Value = 0) %>% ## just to have proper year range at the end
  mutate(group = cut(Year, breaks = seq(1989, 2024, 5), labels = FALSE, include.lowest = TRUE)) %>%
  group_by(group) %>%
  summarize(Year = paste0(min(Year), "-", max(Year)), 
            `Sum of Value` = sum(Value)) %>%
  ungroup() %>%
  mutate(`% of Value` = `Sum of Value`/sum(`Sum of Value`)) %>%
  select(-group)

identical(result, test)
# [1] TRUE
