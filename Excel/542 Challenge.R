library(tidyverse)
library(readxl)

path = "Excel/542 Squares from Strings.xlsx"
test_abc = read_excel(path, range = "C2:E4", col_names = FALSE) %>% as.matrix()
test_abcd = read_excel(path, range = "C6:F9", col_names = FALSE) %>% as.matrix()
test_microsoft = read_excel(path, range = "C11:K19", col_names = FALSE) %>% as.matrix()

make_word_frame <- function(word) {
  n <- nchar(word)
  chars <- str_split(word, "")[[1]]
  M <- matrix(NA, n, n)
  
  M[1, ] <- M[, 1] <- chars
  M[n, ] <- M[, n] <- rev(chars)
  
  return(M)
}

all.equal(make_word_frame("abc"), test_abc, check.attributes = FALSE) # TRUE
all.equal(make_word_frame("abcd"), test_abcd, check.attributes = FALSE) # TRUE
all.equal(make_word_frame("microsoft"), test_microsoft, check.attributes = FALSE) # TRUE

