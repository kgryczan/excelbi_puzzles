library(tidyverse)
library(readxl)
library(countries)

path = "Excel/608 Extract Zip and Country.xlsx"
input = read_excel(path, range = "A2:A12")
test  = read_excel(path, range = "B2:C12")

result = input %>%
  mutate(Zip = str_extract(String, "(?<=\\p{Punct}\\s|^)\\d{5,6}(?=,|\\s{2})") %>% as.numeric(),
         Country = str_extract(String, "(\\w+)? \\w+$") %>% str_trim(),
         is_country = is_country(Country)) %>%
  mutate(Country = ifelse(!is_country, str_extract(String, "\\w+$") %>% str_trim(), Country)) %>%
  select(Zip, Country)

all.equal(result, test)
# [1] TRUE