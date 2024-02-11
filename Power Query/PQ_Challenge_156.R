library(tidyverse)
library(readxl)

input1 = read_excel("Power Query/PQ_Challenge_156.xlsx", range = "A1:B10")
input2 = read_excel("Power Query/PQ_Challenge_156.xlsx", range = "D1:E5")

test = read_excel("Power Query/PQ_Challenge_156.xlsx", range = "G1:K6")

result = input1 %>% 
  left_join(input2, by = "Subjects") %>%
  pivot_wider(names_from = "Subjects", values_from = "Teacher", values_fill =  NA_character_) %>%
  select(Name, Biology, Chemistry, Geology, Physics)

identical(result, test)
# [1] TRUE


