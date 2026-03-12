library(tidyverse)
library(readxl)

path <- "900-999/932/932 Largest Palindrome.xlsx"
input <- read_excel(path, range = "A1:A10")
test <- read_excel(path, range = "B1:B10")

longest_palindrome <- function(s) {
  n <- nchar(s)
  subs <- outer(
    1:n,
    1:n,
    Vectorize(function(i, j) if (i <= j) substr(s, i, j))
  )
  subs <- na.omit(as.vector(subs))
  pals <- subs == stringi::stri_reverse(subs)
  res <- subs[pals]
  res[nchar(res) == max(nchar(res))]
  res <- res[nchar(res) == max(nchar(res)) & nchar(res) > 1]
  paste(res, collapse = ", ")
}

result = input %>%
  mutate(
    palindrome = map_chr(Data, longest_palindrome) %>%
      if_else(. == "", "None", .)
  )

all.equal(result$palindrome, test$`Answer Expected`)
# [1] TRUE
