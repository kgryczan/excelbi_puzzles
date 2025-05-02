library(tidyverse)
library(readxl)

path = "Excel/196 Repititions.xlsx"
input = read_excel(path, range = "A1:A6")
test  = read_excel(path, range = "B1:B6")

result = input %>%
  mutate(`Answer Expected` = map_chr(String, ~ 
                                 str_split(.x, "")[[1]] %>%
                                 imap_chr(~ strrep(.x, .y)) %>%
                                 str_c(collapse = "-")
  ))

