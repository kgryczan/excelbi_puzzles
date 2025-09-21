library(tidyverse)
library(readxl)

path = "Power Query/300-399/324/PQ_Challenge_324.xlsx"
input = read_excel(path, range = "A1:B22")
test  = read_excel(path, range = "D1:G9") %>%
  mutate(across(everything(), ~replace_na(.x, 0)))

result = input %>%
  mutate(Store = ifelse(Data1 == "Store", Data2, NA_character_)) %>%
  fill(Store) %>%
  mutate(`Visit Date` = ifelse(Data1 == "Visit Date", Data2, NA_character_)) %>%
  fill(`Visit Date`, .direction = "up") %>%
  filter(Data2 != Store, Data2 != `Visit Date`) %>%
  select(-c(Data1, `Visit Date`)) %>%
  separate_longer_delim(Data2, ", ") %>%
  rename(Name = Data2) %>%
  count(Name, Store) %>%
  pivot_wider(names_from = Store, values_from = n, values_fill = 0) %>%
  janitor::adorn_totals(c("row", "col"))

all.equal(result, test, check.attributes = FALSE)
# TRUE