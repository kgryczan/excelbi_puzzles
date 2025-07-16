library(tidyverse)
library(readxl)

input = read_excel("Excel/200-299/274/274 Fascinating Numbers.xlsx") %>% select(1)

result = input %>%
  mutate(twice = Numbers * 2,
         thrice = Numbers * 3,
         conc = paste0(as.character(Numbers), as.character(twice), as.character(thrice)),
         vec = unique(str_split(conc,"")), 
         nu_digits = map(vec, n_distinct)) %>%
  filter(nu_digits == 10) %>%
  select(Numbers)

print(result)
