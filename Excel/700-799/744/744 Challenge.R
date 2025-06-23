library(tidyverse)
library(readxl)

path = "Excel/700-799/744/744 Capitalize the Consonant After a Vowel.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")

pattern = "(?<=([aeiou])[0-9]?)([b-df-hj-np-tv-z])"

result = input %>%
  mutate(`Expected Answer` = map_chr(Strings, ~ {
    str_replace_all(.x, pattern, function(x) {
      toupper(x)
    })
  }))

all.equal(result$`Expected Answer`, test$`Expected Answer`, check.attributes = FALSE)
# [1] TRUE
