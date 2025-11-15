library(tidyverse)
library(readxl)

excel_path <- "Power Query/300-399/339/PQ_Challenge_339.xlsx"
input = read_excel(excel_path, range = "A1:A7")
test  = read_excel(excel_path, range = "C1:F7")

result = input %>%
  mutate(
    Country = str_extract(Data, "^[A-Z][a-z]+\\s+([A-Z][a-z]+)?") %>% trimws(),
    `Time Zone` = str_extract(Data, '(?<=\\().+?(?=\\))'),
    Latitude = as.numeric(str_extract(Data, "(?<=LAT )-?[\\d.]+")),
    Longitude = as.numeric(str_extract(Data, "(?<=LONG )-?[\\d.]+"))
  ) %>%
  select(-Data)
  
all.equal(result, test)
# [1] TRUE