library(tidyverse)
library(readxl)

path <- "1000-1099/1051/1051 Sorting Vowel Gap.xlsx"
input <- read_excel(path, range = "A1:A11")
test <- read_excel(path, range = "B1:B11")

sort_vowels <- \(x) {
  chars <- str_split_1(x, "")
  pos <- which(chars %in% c("a", "e", "i", "o", "u"))
  if (!length(pos)) {
    return(x)
  }
  gap <- diff(c(pos, length(chars) + 1)) - 1
  chars[pos] <- chars[pos][
    order(-gap, chars[pos], seq_along(pos))
  ]
  str_c(chars, collapse = "")
}

result <- input %>%
  mutate(Answer = map_chr(Text, sort_vowels))

all.equal(result$Answer, test$`Answer Expected`)
