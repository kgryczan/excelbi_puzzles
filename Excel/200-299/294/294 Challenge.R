library(tidyverse)
library(readxl)

input = read_excel("Tautonyms.xlsx", range = "A1:A10")
test = read_excel("Tautonyms.xlsx", range = "B1:B6")

is_tautonym = function(string) {
  low_str = str_to_lower(string)
  
  cleaned_str = low_str %>% 
    str_remove_all(pattern = "[:punct:]") %>%
    str_remove_all(pattern = "[:space:]")
  
  str_len = str_length(cleaned_str)
  
  if (str_len %% 2 != 0) {
    return(FALSE)
  } else {
    first_part = str_sub(cleaned_str, 1, str_len/2)
    second_part = str_sub(cleaned_str, (str_len/2)+1, str_len)
    return(first_part == second_part)
  }
}

result = input %>%
  mutate(is_tautonym = map_lgl(Words, is_tautonym)) %>%
  filter(is_tautonym == TRUE) %>%
  select(`Answer Expected` = Words)