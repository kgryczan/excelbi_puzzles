library(tidyverse)
library(readxl)
path <- "Excel/800-899/850/850 First Missing Letter.xlsx"
input <- read_excel(path, range = "A1:A11")
test <- read_excel(path, range = "B1:B11") %>% replace_na(list(`Answer Expected` = ""))

words <- input$Data

state <- reduce(
  words,
  .init = list(
    alphabet = letters,
    results  = character()
  ),
  .f = function(acc, word) {
    chars_now <- str_split_1(str_to_lower(word), "") %>% unique()
    alphabet_new <- setdiff(acc$alphabet, chars_now)
    chosen <- if (length(alphabet_new) == 0) "" else alphabet_new[1]
    alphabet_new <- setdiff(alphabet_new, chosen)
    list(
      alphabet = alphabet_new,
      results  = c(acc$results, chosen)
    )
  }
)
result <- tibble(final_missing = state$results)

all.equal(result$final_missing, test$`Answer Expected`)
# [1] TRUE