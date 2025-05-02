library(tidyverse)
library(readxl)

path = "Excel/568 Fill in the Alphabets.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")

fill_words = function(string) {
  lets = strsplit(string, "")[[1]]
  pairs = map(1:(length(lets) - 1), ~paste(lets[.x:(.x + 1)], collapse = ""))

  df = tibble(
    first = map_chr(pairs, ~str_sub(.x, 1, 1)),
    second = "",
    third = map_chr(pairs, ~str_sub(.x, 2, 2))
  )
  
  df = df %>%
    mutate(
      second = map2_chr(first, third, ~{
        first_num = as.numeric(charToRaw(.x))
        third_num = as.numeric(charToRaw(.y))
        letters = map_chr((first_num):(third_num), ~rawToChar(as.raw(.x)))
        paste(letters, collapse = "") %>% str_sub(2, -2)
      }),
      third = if_else(row_number() == n(), "", third)
    ) %>%
    unite("word", c("first", "second", "third"), sep = "") %>%
    pull(word) %>%
    paste(collapse = "")
  
  return(df)
}

fill_words("planet")

result = input %>%
  mutate(`Answer Expected` = map_chr(Words, fill_words)) %>%
  select(-Words)

all.equal(result$`Answer Expected`, test$`Answer Expected`, check.attributes = FALSE)
#> [1] TRUE