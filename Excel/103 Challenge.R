library(tidyverse)
library(readxl)

path = "Excel/103 Caesars Cipher_3.xlsx"
input = read_excel(path, range = "A1:B10")
test  = read_excel(path, range = "C1:C10")

code_ceasar = function(text, shift) {
  text = strsplit(text, "")[[1]]
  text = map_chr(text, ~{
    if (grepl("[A-Z]", .)) {
      LETTERS[(match(toupper(.), LETTERS) + shift - 1) %% 26 + 1]
    } else if (grepl("[a-z]", .)) {
      letters[(match(tolower(.), letters) + shift - 1) %% 26 + 1]
    } else if (grepl("[0-9]", .)) {
      as.character((as.numeric(.) + shift ) %% 10)
    } else {
      .
    }
  }) %>% paste0(collapse = "")
  return(text)
}

result = input %>%
  mutate(result = map2_chr(Text, Shift, code_ceasar))

all.equal(result$result, test$`Expected Answer`)
#> [1] TRUE