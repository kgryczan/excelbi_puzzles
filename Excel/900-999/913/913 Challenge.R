library(tidyverse)
library(readxl)

path <- "Excel/900-999/913/913 Vowel Replacement.xlsx"
input <- read_excel(path, range = "A1:A10")
test <- read_excel(path, range = "B1:B10")

process <- function(x) {
  vowels <- c("a", "e", "i", "o", "u")

  data.frame(col1 = x) %>%
    separate_rows(col1, sep = "") %>%
    mutate(
      low = tolower(col1),
      is_v = low %in% vowels,
      grp = if_else(is_v, low, paste0("c_", row_number()))
    ) %>%
    group_by(grp) %>%
    mutate(
      freq = if_else(is_v, row_number(), 0L),
      keep = !is_v | freq == max(freq)
    ) %>%
    ungroup() %>%
    mutate(
      col1 = case_when(
        !keep ~ "",
        is_v ~ as.character(freq),
        TRUE ~ col1
      )
    ) %>%
    summarise(col1 = paste0(col1, collapse = "")) %>%
    pull(col1)
}

result <- input %>%
  mutate(`Answer Expected` = map_chr(Names, process))

all.equal(result$`Answer Expected`, test$`Answer Expected`)
