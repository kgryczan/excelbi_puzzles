library(tidyverse)
library(readxl)

input = read_excel("Power Query/PQ_Challenge_169.xlsx", range = "A1:A8")
test = read_excel("Power Query/PQ_Challenge_169.xlsx", range = "C1:D8")

pattern = ("\\b[A-Z](?=[A-Z0-9]*[0-9])[A-Z0-9]*\\b")

result = input %>%
  mutate(Codes = map_chr(String, ~str_extract_all(., pattern) %>% unlist() %>% 
                              str_c(collapse = ", "))) %>%
  mutate(Codes = if_else(Codes == "", NA_character_, Codes)) 

all.equal(test$Codes, result$Codes)
# [1] TRUE

