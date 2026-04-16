library(tidyverse)
library(readxl)

path <- "900-999/957/957 Split.xlsx"
input <- read_excel(path, range = "A1:B10")
test <- read_excel(path, range = "C1:C10")

split_string <- function(data, rules) {
  if (is.na(rules) || rules == "(none)") {
    return(data)
  }
  tokens <- str_split(rules, ",")[[1]] %>% str_trim()
  cut_points <- c()
  for (tok in tokens) {
    if (str_starts(tok, "@")) {
      chars <- str_split(data, "")[[1]]
      pattern <- c(`@DIGIT` = "\\d", `@UPPER` = "[A-Z]", `@ALPHA` = "[A-Za-z]")[tok]
      if (!is.na(pattern)) {
        cut_points <- c(cut_points, which(str_detect(chars, pattern)) - 1)
      }
    } else {
      pos <- as.integer(tok)
      cut_points <- c(cut_points, pos)
    }
  }
  all_cuts <- sort(unique(c(0, cut_points, nchar(data))))
  parts <- map2_chr(
    all_cuts[-length(all_cuts)],
    all_cuts[-1],
    ~ substr(data, .x + 1, .y)
  )
  parts <- parts[parts != ""]
  paste(parts, collapse = " | ")
}
result <- input %>%
  mutate(Answer = map2_chr(Data, Split_Rules, split_string))

all.equal(result$Answer, test$`Answer Expected`)
# [1] TRUE
