library(tidyverse)
library(readxl)
library(charcuterie)

path = "Excel/589 Longest Words in English.xlsx"
input = read_excel(path, range = "A2:A7")
test  = read_excel(path, range = "B2:C7")

result = input %>%
  mutate(chars = map(Words, chars)) %>%
  mutate(`Missing Alphabets` = map2(Words, chars, ~setdiff(letters, .y)),
         `Highest Frequency` = map2(Words, chars, ~{
           count = table(strsplit(.x, "")[[1]])
           max_count = max(count)
           max_letter = names(count)[count == max_count]
           max_letter
         })) %>%
  select(-chars) %>%
  mutate(`Missing Alphabets` = map_chr(`Missing Alphabets`, ~paste(.x, collapse = ", ")),
         `Highest Frequency` = map_chr(`Highest Frequency`, ~paste(.x, collapse = ", ")))

all.equal(result[2:3], test)
#> [1] TRUE