library(tidyverse)
library(readxl)

path = "Excel/700-799/789/789 Fill in Missing Alphabets.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")

fill_letters = function(s) {
  chars = str_split_1(s, "")
  filled = chars[1]
  for (i in 2:length(chars)) {
    prev = chars[i - 1]
    curr = chars[i]
    if (prev == curr) {
      filled = paste0(filled, curr)
    } else {
      seq_chars = intToUtf8(seq(utf8ToInt(prev), utf8ToInt(curr), 
                                 by = ifelse(prev < curr, 1, -1)))
      filled = paste0(filled, substring(seq_chars, 2))
    }
  }
  filled
}

result = input %>%
  mutate(`Expected Answer` = map_chr(Words, fill_letters))

all.equal(result$`Expected Answer`, test$`Expected Answer`)
# > [1] TRUE