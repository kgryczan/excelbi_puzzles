library(tidyverse)
library(readxl)

input = read_excel("Excel/449 Rotated Strings.xlsx", range = "A1:B10") %>% arrange(String1)
test  = read_excel("Excel/449 Rotated Strings.xlsx", range = "C1:D6") %>% arrange(`Answer Expected`)
colnames(test) = colnames(input)

# approach 1

is_rotated = function(string1, string2) {
  is_0_rot = string1 == string2
  is_rot = str_detect(paste0(string1, string1), string2)
  return(is_rot & !is_0_rot)
}

result = input %>%
  mutate(is_rotated = map2_lgl(String1, String2, is_rotated)) %>%
  filter(is_rotated) %>%
  select(-is_rotated)

identical(result, test)
# [1] TRUE


# approach 2 

result2 = input %>% 
  filter(map2_lgl(String1, String2, ~str_detect(paste0(.x, .x), .y) & .x != .y))

identical(result2, test)
# [1] TRUE