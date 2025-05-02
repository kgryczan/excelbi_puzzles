library(tidyverse)
library(readxl)

path = "Excel/551 Watson-Crick Palindromes.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")

compliment = function(x) {
  recode(x, "A" = "T", "T" = "A", "C" = "G", "G" = "C", .default = "N")
}

result = input %>%
  mutate(nchar = nchar(.$String),
         pos = str_locate(.$String, "X"),
         char = str_sub(.$String, nchar - pos[,1] + 1, nchar - pos[,1] + 1),
         compliment = compliment(.$char)) %>%
  select(`Answer Expected` = compliment)


identical(result, test)
#> [1] TRUE