library(tidyverse)
library(readxl)

path = "Excel/800-899/833/833 Summarize.xlsx"
input = read_excel(path, range = "A2:C14")
test  = read_excel(path, range = "E2:H5")

result = input %>%
  mutate(Date = ifelse(!is.na(Task), Data, NA)) %>%
  fill(Date, Task) %>%
  filter(Data != Date) %>%
  summarise(Amount = sum(Data, na.rm = TRUE), .by = c(Store, Date, Task)) %>%
  mutate(Date = janitor::excel_numeric_to_date(Date) %>% as.POSIXct())

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE