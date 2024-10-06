library(tidyverse)
library(readxl)
library(charcuterie)

path = "Excel/130 Capitalize First & Last Letters.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")

capitalize_first_and_last = function(x) {
  words = str_split(x, " ")[[1]]
  words = map(words, ~chars(.x))
  words = map(words, ~{
    .x[1] = str_to_upper(.x[1])
    .x[length(.x)] = str_to_upper(.x[length(.x)])
    .x
  })
  words = map(words, string) %>% str_c(collapse = " ")
  return(words)
}

result = input %>%
  mutate(`Expected Answer` = map_chr(Authors, capitalize_first_and_last)) 

all.equal(result$`Expected Answer`, test$`Expected Answer`)  
# TRUE