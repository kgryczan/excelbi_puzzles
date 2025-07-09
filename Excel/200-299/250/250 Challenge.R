library(tidyverse)
library(readxl)

path = "Excel/200-299/250/250 Password Classification.xlsx"
input = read_excel(path, range = "A1:A9")
test  = read_excel(path, range = "B1:B9")

result = input %>%
  mutate(count = str_length(Password),
         contain_digit = str_detect(Password, "[0-9]"),
         contain_letter = str_detect(Password, "[A-Za-z]"),
         contain_symbol = str_detect(Password, "[[:punct:]]|[[:symbol:]]"),
         counter = contain_digit + contain_letter + contain_symbol) %>%
  mutate(classification = case_when(
    count < 8 ~ "Invalid",
    counter == 1 ~ "Weak",
    counter == 2 ~ "Strong",
    counter == 3 & count < 16 ~ "Very Strong",
    counter == 3 & count >= 16 ~ "Best"
  )) %>%
  select(Password, classification)

all.equal(result$classification, test$`Answer Expected`)
# > [1] TRUE