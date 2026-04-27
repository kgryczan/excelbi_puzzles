library(tidyverse)
library(readxl)

path <- "900-999/964/964  Append letters at the end till finish.xlsx"
input <- read_excel(path, range = "A1:A7")
test <- read_excel(path, range = "B1:B7")

decon <- function(string) {
  str_c(
    map_chr(1:nchar(string), ~ str_sub(string, .x, nchar(string))),
    collapse = ""
  )
}

result = input %>%
  mutate(rn = row_number()) %>%
  separate_longer_delim(Strings, delim = " ") %>%
  mutate(Strings = map_chr(Strings, decon)) %>%
  summarise(`Answer Expected` = str_c(Strings, collapse = " "), .by = rn) %>%
  select(-rn)

all.equal(result, test)
# [1] TRUE
