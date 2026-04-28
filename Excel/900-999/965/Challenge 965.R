library(tidyverse)
library(readxl)

path <- "900-999/965/965 Find Words in Rows in a Grid.xlsx"
input <- read_excel(path, range = "A1:H9", col_names = FALSE) %>% as.matrix()
input2 <- read_excel(path, range = "J1:J6")$Word
test <- read_excel(path, range = "K1:K6")

cols <- LETTERS[seq_len(ncol(input))]
rows <- seq_len(nrow(input)) + 2
grid_str <- apply(input, 1, paste0, collapse = "")
find_word <- \(w) {
  str_locate_all(grid_str, w) %>%
    map2(rows, \(h, r) {
      if (nrow(h) == 0) {
        return(character(0))
      }
      paste0(cols[h[, 1]], r - 2, ":", cols[h[, 2]], r - 2)
    }) %>%
    list_c() %>%
    {
      \(x) if (length(x)) paste(sort(x), collapse = ", ") else "Not Found"
    }()
}
result = setNames(map_chr(input2, find_word), input2) %>%
  enframe(name = "Word", value = "Locations")

all.equal(test$`Answer Expected`, result$Locations)
# [1] TRUE
