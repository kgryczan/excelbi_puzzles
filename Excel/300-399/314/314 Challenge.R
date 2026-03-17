library(tidyverse)
library(readxl)

path <- "300-399/313/313 Atbash Palindromes.xlsx"
input <- read_excel(path, range = "A1:A10")
test  <- read_excel(path, range = "B1:B4")

is_atbash_palindrome <- function(word) {
  chars <- utf8ToInt(word) - utf8ToInt("A") + 1L
  all(chars + rev(chars) == 27L)
}

result <- input %>%
  filter(map_lgl(Text, is_atbash_palindrome)) %>%
  select(Text)

all.equal(result$Text, test$`Answer Expected`)
# [1] TRUE
