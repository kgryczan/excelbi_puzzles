library(tidyverse)
library(readxl)
library(janitor)

path = "Power Query/PQ_Challenge_273.xlsx"
input = read_excel(path, range = "A1:B20")
test  = read_excel(path, range = "D1:F18")

result = input %>%
  mutate(Store = ifelse(Data1 == "Store", Data2, NA)) %>%
  fill(Store) %>%
  filter(Data1 != "Store") %>%
  mutate(`Visit Date` = ifelse(Data1 == "Visit Date", Data2, NA)) %>%
  fill(`Visit Date`, .direction = "up") %>%
  filter(Data1 != "Visit Date") %>%
  mutate(`Visit Date` = excel_numeric_to_date(as.numeric(`Visit Date`)) %>% as.POSIXct()) %>%
  separate_rows(Data2, sep = ", ") %>%
  select(Store, Customer = Data2, `Visit Date`) 

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE