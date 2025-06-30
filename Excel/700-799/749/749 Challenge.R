library(tidyverse)
library(readxl)

path = "Excel/700-799/749/749 Portmanteau Words v2.xlsx"
input1 = read_excel(path, range = "A1:A10")
input2 = read_excel(path, range = "B1:C10")
test  = read_excel(path, range = "D1:D6")

get_all_substrings =  function(x) {
  if (is.na(x) || x == "") return(character(0))
  len =  nchar(x)
  unique(c(substring(x, 1, 1:len), substring(x, len:1, len)))
}

result =  input2 %>%
  mutate(port1 = map2(Word1, Word2, ~ {
    s1 =  get_all_substrings(.x)
    s2 =  get_all_substrings(.y)
    ports =  as.vector(outer(s1, s2, paste0))
    intersect(ports, input1$Word)
  })) %>%
  select(port1) %>%
  unnest(port1) %>%
  arrange(port1)

all.equal(result$port1, test$`Answer Expected`, check.attributes = FALSE)
# [1] TRUE