library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_261.xlsx"
input = read_excel(path, range = "A1:B13")
test  = read_excel(path, range = "D1:F12")

result = input %>%
  mutate(Country = ifelse(Data1 == "Country", Data2, NA),
         State = ifelse(Data1 == "State", Data2, NA),
         Cities = ifelse(Data1 == "Cities", Data2, NA)) %>%
  fill(Country, State) %>%
  select(-Data1, -Data2) %>%
  filter(!is.na(Cities)) %>%
  separate_rows(Cities, sep = ", ") %>%
  mutate(across(c(Country, State, Cities), str_trim)) %>%
  mutate(Country = ifelse(row_number() == 1, Country, NA), .by = Country) %>%
  mutate(State = ifelse(row_number() == 1, State, NA), .by = State)

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE