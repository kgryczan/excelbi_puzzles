library(tidyverse)
library(readxl)

path <- "900-999/996/996 Abbreviation for List of Elements.xlsx"
input <- read_excel(path, range = "A1:A119")
test <- read_excel(path, range = "B1:B119")

used <- character()
result <- input %>%
  mutate(
    Answer = map_chr(Elements, \(x) {
      ab <- setdiff(str_sub(x, 1, seq_len(str_length(x))), used)[1]
      used <<- c(used, ab)
      ab
    })
  )

all.equal(result$Answer, test$`Answer Expected`)
# [1] TRUE
