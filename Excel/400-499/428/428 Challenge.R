library(tidyverse)
library(readxl)

input = read_excel("Excel/428 Chinese National ID.xlsx", range = "A1:A10")
test  = read_excel("Excel/428 Chinese National ID.xlsx", range = "B1:B5")

general_pattern = "\\d{6}\\d{8}\\d{3}[0-9X]"
is_valid_date = function(ID) {
  str_sub(ID, 7, 14) %>% ymd()
  if (is.na(date)) {
    return(FALSE)
  } else {
    return(TRUE)
  }
}

is_ID_valid = function(ID) {
  base = str_sub(ID, 1, 17) %>% str_split("") %>% unlist() %>% as.numeric()
  I = 18:2
  WI = 2**(I-1) %% 11
  S = sum(base * WI)  
  C = (12 - (S %% 11)) %% 11
  C = as.character(C) %>% str_replace_all("10", "X")

  whole_id = base %>% str_c(collapse = "") %>% str_c(C)
  return(whole_id == ID)
}


r1 = input %>%
  mutate(gen_pattern = str_match(`National ID`, general_pattern)) %>%
  mutate(dob = str_sub(`National ID`, 7, 14) %>% ymd()) %>%
  mutate(is_valid = map_lgl(`National ID`, is_ID_valid)) %>%
  filter(is_valid == TRUE & !is.na(dob) & !is.na(gen_pattern)) %>%
  select(`Answer Expected` = `National ID`)

identical(r1, test)
# [1] TRUE
