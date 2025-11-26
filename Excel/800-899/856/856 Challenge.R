library(tidyverse)
library(readxl)

path <- "Excel/800-899/856/856 Capitalize Consonants Around Vowels.xlsx"
input <- read_excel(path, range = "A1:A10")
test <- read_excel(path, range = "B1:B10")

result = input %>%
  mutate(
    out = str_replace_all(
      Authors,
      "(?<=[aeiou])([^aeiou])|([^aeiou])(?=[aeiou])",
      ~ toupper(.x)
    )
  )

all.equal(result$out, test$`Expected Answer`)
# [1] TRUE
