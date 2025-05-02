library(tidyverse)
library(readxl)

path = "Excel/203 Baconian Cipher.xlsx"
input = read_excel(path, range = "A1:A7")
test  = read_excel(path, range = "B1:B7")

to_binary <- function(letter) {
  sapply(letter, function(x) {
    if (grepl("[A-Z]", x)) {
      idx <- as.integer(charToRaw(x)) - as.integer(charToRaw("A"))
    } else if (grepl("[a-z]", x)) {
      idx <- as.integer(charToRaw(x)) - as.integer(charToRaw("a"))
    } else {
      stop("Only alphabetical letters are allowed.")
    }
    bits <- intToBits(idx)[1:5]
    paste0(rev(as.integer(bits)), collapse = "")
  })
}

result = input %>%
  mutate(rn = row_number()) %>%
  separate_rows(Words, sep = "") %>%
  filter(Words != "") %>%
  mutate(Bits = to_binary(Words)) %>%
  summarise(Bits = paste(Bits, collapse = ""), .by = rn) %>%
  mutate(Bits = str_replace_all(Bits, c("1" = "b", "0" = "a")))
  
all.equal(result$Bits, test$`Answer Expected`)
#> [1] TRUE