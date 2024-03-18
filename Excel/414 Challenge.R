library(tidyverse)
library(readxl)

input = read_excel("Excel/414 IMO Number of a Vessel.xlsx", range = "A1:A10") %>%
  filter(!`IMO Number` %in% c("36X7567", "41X6584")) 
test  = read_excel("Excel/414 IMO Number of a Vessel.xlsx", range = "A1:B10") %>%
  filter(!`IMO Number` %in% c("36X7567", "41X6584"))

# "41X6584" and "36X7567" has 5 possible values for X 

find_missing_digit = function(x) {
  digits = as.character(x) %>%
    str_split("") %>%
    unlist()

  pos = which(digits == "X")
  mults = 7:1
  
  if (pos == 7) {
    missing = sum(as.numeric(digits[1:6]) * mults[1:6]) %% 10 %>% as.character()
  }  
  else {
    missing_mult = 8 - pos
    checking_number = digits[7]
    df = data.frame(digits = digits[-pos], mults = mults[-pos]) %>%
      mutate(digits = as.numeric(digits)) %>%
      filter(mults != 1) %>%
      mutate(multiplicated = digits * mults) %>%
      summarise(sum = sum(multiplicated)) %>%
      pull()
    
    missing = data.frame(digits = 0:9, ch = checking_number, mm = missing_mult, sum = df) %>%
      mutate(sum = (sum + (digits * missing_mult)) %% 10,
             check = sum == ch) %>%
      filter(check) %>%
      select(digits) %>%
      pull() %>%
      as.character()
    }
  
  result = str_replace(x, "X", missing) %>% as.numeric()
  return(result)
}

result = input %>%
  mutate(`Answer Expected` = map_dbl(`IMO Number`, find_missing_digit)) 

identical(result, test)
# [1] TRUE
