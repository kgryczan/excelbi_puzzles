library(tidyverse)
library(readxl)

path = "Excel/200-299/247/247 Atbash Cipher2.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")

atbash = function(x) {
  map_chr(str_split(x, "", simplify = TRUE), ~ {
    if (.x %in% letters) letters[27 - match(.x, letters)]
    else if (.x %in% LETTERS) LETTERS[27 - match(.x, LETTERS)]
    else if (.x %in% 0:9) as.character(9 - as.numeric(.x))
    else .x
  }) %>% paste(collapse = "")
}

result = input %>%
  mutate(Atbash = map_chr(Text, atbash)) %>%
  select(-Text)

all.equal(result$Atbash, test$`Expected Answer`, check.attributes = FALSE)
# > [1] TRUE