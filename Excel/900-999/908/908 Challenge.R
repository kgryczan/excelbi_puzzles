library(tidyverse)
library(readxl)

path <- "Excel/900-999/908/908 States and Capitals.xlsx"
input <- read_excel(path, range = "A2:A12")
test <- read_excel(path, range = "B2:D12")

result = input %>%
  mutate(
    ID = str_extract(Data, "[0-9]{2}"),
    Capital = str_extract(Data, "[A-Z][a-z]+(?:[A-Z][a-z]+)*"),
    `State Code` = str_extract(Data, "[A-Z]{2}")
  ) %>%
  select(-Data)

all.equal(result, test)
# [1] TRUE
