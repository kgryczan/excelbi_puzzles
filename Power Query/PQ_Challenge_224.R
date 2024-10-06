library(tidyverse)
library(readxl)
library(janitor)

path = "Power Query/PQ_Challenge_224.xlsx"
input = read_excel(path, range = "A1:D12")
test  = read_excel(path, range = "F1:I20")

result = input %>%
  mutate(date = ifelse(str_detect(Column1, "\\d"), Column1, NA)) %>%
  fill(date) %>%
  set_names(.[1, ]) %>%
  rename("Name" = 1, "date" = 5) %>%
  filter(!str_detect(Name, "\\d")) %>%
  mutate(date = coalesce(excel_numeric_to_date(as.numeric(date)), mdy(date))) %>%
  pivot_longer(-c(date, Name), names_to = "Data", values_to = "Value") %>%
  na.omit() %>%
  select(Date = date, Name, Data, Value) %>%
  mutate(Value = as.numeric(Value), 
         Date = as.POSIXct(Date))

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE
