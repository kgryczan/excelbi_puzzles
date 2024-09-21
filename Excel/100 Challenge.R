library(tidyverse)
library(readxl)

path = "Excel/100 Vowel Replacement.xlsx"
input = read_excel(path, range = "A1:A6")
test  = read_excel(path, range = "B1:B6")

dict = data.frame(key = c(LETTERS, letters), value = c(LETTERS, letters)) %>%
  mutate(value = str_replace(value, "[^aeiouAEIOU]", NA_character_)) %>%
  fill(value, .direction = "down") 

result = input %>%
  mutate(replaced = str_replace_all(String, setNames(dict$value, dict$key)))

all.equal(result$replaced, test$Result)
# mistake in Linkedin word. should be capital first letter.
