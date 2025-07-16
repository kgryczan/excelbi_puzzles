library(tidyverse)
library(readxl)

path = "Excel/200-299/270/270 Case of Sentences.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")

case_detect = function(sentence) {
  case = case_when(
    str_to_lower(sentence) == sentence ~ "All Lowercase",
    str_to_upper(sentence) == sentence ~ "All Caps",
    str_to_title(sentence) == sentence ~ "Start Case",
    str_to_sentence(sentence) == sentence ~ "Sentence Case",
    TRUE ~ "Mixed Case"
  )
}

result = input %>%
  mutate(Case = map_chr(Sentence, case_detect))

all.equal(result$Case, test$`Answer Expected`, check.attributes = FALSE)
#> [1] TRUE