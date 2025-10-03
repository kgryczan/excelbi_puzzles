library(tidyverse)
library(readxl)

path = "Excel/800-899/817/817 Maths Operations.xlsx"
input = read_excel(path, range = "A1:A20")
test  = read_excel(path, range = "C1:C10")

  result = input %>%
    mutate(expre = case_when(
      Data %in% c("+", "-", "*", "/") ~ paste(lag(Data), Data, lead(Data)),
      str_detect(coalesce(Data, ""), "^[0-9]+$") & 
        (lag(Data) %in% c("+", "-", "*", "/") | 
        lead(Data) %in% c("+", "-", "*", "/")) ~ NA_character_,
      str_detect(coalesce(Data, ""), "^[0-9]+$") ~ Data,
      TRUE ~ NA_character_
      )) %>%
  select(expre) %>%
  filter(!is.na(expre)) %>%
  mutate(result = map_dbl(expre, ~ eval(parse(text = .x))))

all.equal(result$result, test$`Answer Expected`)
# [1] TRUE