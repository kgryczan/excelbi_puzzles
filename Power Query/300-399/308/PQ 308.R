library(tidyverse)
library(readxl)
library(janitor)

path = "Power Query/300-399/308/PQ_Challenge_308.xlsx"
input = read_excel(path, range = "B2:B6")
test  = read_excel(path, range = "D2:F7")

result = input %>%
  extract(Data, into = c("Company", "Data"), 
          regex = "(Company [A-Z]{1})(.*)") %>%
  mutate(Data = str_trim(str_to_lower(Data))) %>%
  mutate(Data = str_extract_all(Data, "[a-z]+[\\s:-]*\\d+")) %>%
  unnest_longer(Data) %>%
  mutate(Data_1 = str_extract(Data, "[a-z]+"),
         Data_2 = str_extract(Data, "\\d+")) %>%
  mutate(Data_2 = as.numeric(Data_2)) %>%
  filter(Data_1 != "year") %>%
  select(-Data) %>%
  pivot_wider(names_from = Data_1, values_from = Data_2, values_fn = sum) %>%
  rename_with(~ str_to_title(.), everything()) %>%
  adorn_totals("row")

all.equal(result, test, check.attributes = FALSE)
# > [1] TRUE