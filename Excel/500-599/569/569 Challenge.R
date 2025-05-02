library(tidyverse)
library(readxl)

path = "Excel/569 Diff of Common Counts.xlsx"
input = read_excel(path, range = "A1:B10") %>% replace_na(list(String1 = "", String2 = ""))
test  = read_excel(path, range = "C1:C10") 

process_strings = function(str1, str2) {
  count_letters = function(str) {
    lets = str_split(str_to_lower(str), "")[[1]]
    df = letters %>%
      tibble(letter = .) %>%
      mutate(count = map_int(letter, ~ sum(.x == lets)))
  }
  s1 = count_letters(str1)
  s2 = count_letters(str2)
  
  s = s1 %>%
    left_join(s2, by = "letter") %>%
    mutate(diff = abs(count.x - count.y)) %>%
    filter(diff != 0) %>%
    select(letter, diff) %>%
    unite("letter_diff", letter, diff, sep = "") %>%
    pull() %>%
    paste0(collapse = "")
  return(s)
}

result = input %>%
  mutate(`Answer Expected` = map2_chr(String1, String2, process_strings))

all.equal(result$`Answer Expected`, test$`Answer Expected`)
#> [1] TRUE