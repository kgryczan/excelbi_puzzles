library(tidyverse)
library(readxl)

path = "Excel/579 Rotated Strings_2.xlsx"
input = read_excel(path, range = "A1:B10")
test  = read_excel(path, range = "C2:D6", col_names = c("Var1", "Var2")) %>%
  arrange(Var1)

is_rotated = function(string1, string2) {
  is_0_rot = string1 == string2
  is_rot = str_detect(paste0(string1, string1), string2)
  is_length_equal = nchar(string1) == nchar(string2)
  return(is_rot & !is_0_rot & is_length_equal)
}

result = expand.grid(input$String1, input$String2) %>%
  mutate(Var1 = as.character(Var1),
         Var2 = as.character(Var2)) %>%
  mutate(is_rotated = map2_lgl(Var1, Var2, is_rotated)) %>%
  filter(is_rotated) %>%
  select(-is_rotated) %>%
  arrange(Var1)

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE