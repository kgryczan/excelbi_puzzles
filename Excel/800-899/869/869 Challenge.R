library(tidyverse)
library(readxl)

path <- "Excel/800-899/869/869 Extract nums.xlsx"
input <- read_excel(path, range = "A1:A100")
test <- read_excel(path, range = "B1:B100")

extract_inc_seq_simple <- function(s) {
  digits <- as.numeric(strsplit(s, "")[[1]])
  result <- numeric(0)
  last_num <- -Inf
  i <- 1

  while (i <= length(digits)) {
    found <- FALSE
    for (j in i:length(digits)) {
      candidate <- as.numeric(paste(digits[i:j], collapse = ""))
      if (candidate > last_num) {
        result <- c(result, candidate)
        last_num <- candidate
        i <- j + 1
        found <- TRUE
        break
      }
    }
    if (!found) break
  }

  return(paste(result, collapse = ", "))
}

result <- input %>%
  mutate(Extracted = map_chr(Data, extract_inc_seq_simple))

all(result$Extracted == test$`Answer Expected`)
# [1] TRUE
