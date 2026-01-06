library(tidyverse)
library(readxl)

path <- "Excel/800-899/885/885 Case Position Swap Cipher.xlsx"
input <- read_excel(path, range = "A1:A20")
test <- read_excel(path, range = "B1:B20")

swap_case_pos <- function(s) {
  up = str_which(str_split(s, "")[[1]], "[A-Z]")
  low = str_which(str_split(s, "")[[1]], "[a-z]")
  s_vec = str_split(s, "")[[1]]
  for (i in seq_along(up)) {
    pos = up[i]
    if (i <= length(low)) {
      swap_pos = low[i]
      temp = s_vec[pos]
      s_vec[pos] = s_vec[swap_pos]
      s_vec[swap_pos] = temp
    }
  }
  return(paste0(s_vec, collapse = ""))
}
result <- input %>%
  mutate(Output = map_chr(CipherText, swap_case_pos))

all.equal(result$Output, test$`Answer Expected`)
# [1] TRUE
