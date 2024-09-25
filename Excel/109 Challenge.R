library(tidyverse)
library(readxl)

path = "Excel/109 Gaderpoluki Cipher1.xlsx"
input = read_excel(path, range = "A1:B7")
test  = read_excel(path, range = "C1:C7")

prepare_mapping <- function(key) {
  chars <- unlist(strsplit(gsub("-", "", key), "")) %>%
    matrix(ncol = 2, byrow = TRUE) %>%
    as.data.frame(stringsAsFactors = FALSE)

  colnames(chars) <- c("from", "to")
  chars <- rbind(chars, data.frame(from = tolower(chars$from), to = tolower(chars$to)))
  return(chars)
}

map_sentence <- function(sentence, mapping) {
  sentence <- unlist(strsplit(sentence, "")) %>%
    map_chr(~ ifelse(.x %in% mapping$from, mapping$to[which(mapping$from == .x)], .x)) %>%
    paste0(collapse = "")
  return(sentence)
}

result = input %>%
  mutate(Answer = map2_chr(input$Key, input$Sentence, ~ map_sentence(.y, prepare_mapping(.x))))

all.equal(result$Answer, test$Answer)
#> [1] TRUE