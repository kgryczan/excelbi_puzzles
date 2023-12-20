library(tidyverse)
library(readxl)

input = read_excel("Reverse Words between Positions.xlsx", range = "A1:C9")
test  = read_excel("Reverse Words between Positions.xlsx", range = "D1:D9")

reverse_words <- function(text, start_pos, end_pos) {
  words <- str_split(text, " ")[[1]]
  words[start_pos:end_pos] <- rev(words[start_pos:end_pos])
  words <- words[!is.na(words)]
  paste(words, collapse = " ")
}

result = input %>% 
  mutate(reversed = pmap_chr(list(text = Sentence, 
                                  start_pos = `Word No1`, 
                                  end_pos = `Word No2`), reverse_words)) %>%
  select(reversed)

identical(test$`Answer Expected`, result$reversed)
#> [1] TRUE