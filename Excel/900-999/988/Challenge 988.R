library(tidyverse)
library(readxl)

path <- "900-999/988/988 Unique Substrings.xlsx"
input <- read_excel(path, range = "A1:A19")
test <- read_excel(path, range = "B1:B19")

find_signatures <- function(string) {
  if (nchar(string) < 3) {
    return(0L)
  }
  seq_len(nchar(string) - 2) %>%
    map_chr(
      ~ substr(string, .x, .x + 2) %>%
        strsplit("") %>%
        .[[1]] %>%
        sort() %>%
        paste(collapse = "")
    ) %>%
    unique() %>%
    length()
}
result = input %>%
  mutate(`Answer Expected` = map_int(Data, find_signatures))

all.equal(result$`Answer Expected`, test$`Answer Expected`)
# Some results don't match the expected output.
