library(tidyverse)
library(readxl)

input = read_excel("Power Query/PQ_Challenge_177.xlsx", range = "A1:F10")
test  = read_excel("Power Query/PQ_Challenge_177.xlsx", range = "H1:M10")

result = input %>%
  rowwise() %>%
  mutate(Result = if_else(any(c(Marks1, Marks2, Marks3) < 40), "Fail", "Pass"),
         total = Marks1 + Marks2 + Marks3) %>%
  ungroup() %>%
  mutate(average = mean(total), 
         rn = row_number(),
         .by = Name) 

aux_rank = result %>%
  select(Name, average) %>%
  distinct() %>%
  mutate(Rank = rank(-average))

result2 = result %>%
  left_join(aux_rank, by = "Name") %>%
  select(Name, Classs, Subject, `Total Marks` = total, Result, Rank, rn) %>%
  mutate(Name = ifelse(rn == 1, Name, NA_character_),
         Classs = ifelse(rn == 1, Classs, NA_real_),
         Rank = ifelse(rn == 1, Rank, NA_integer_)) %>%
  select(-rn)

identical(result2, test) 
#> [1] TRUE

