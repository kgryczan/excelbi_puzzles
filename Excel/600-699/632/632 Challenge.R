library(tidyverse)
library(readxl)

path <- "Excel/632 Create Triangle from Words.xlsx"
test1 <- read_excel(path, range = "B2:D3", col_names = FALSE) %>% as.matrix()
test2 <- read_excel(path, range = "B5:F7", col_names = FALSE) %>% as.matrix()
test3 <- read_excel(path, range = "B9:F11", col_names = FALSE) %>% as.matrix()
test4 <- read_excel(path, range = "B13:H16", col_names = FALSE) %>% as.matrix()
test5 <- read_excel(path, range = "B18:J23", col_names = FALSE) %>% as.matrix()

triangular_numbers <- function(n) {
  n * (n + 1) / 2
}

draw_triangle_from_word <- function(word) {
  n <- 1
  while (triangular_numbers(n) < nchar(word)) {
    n <- n + 1
  }
  
  padded_word <- paste0(word, strrep("#", triangular_numbers(n) - nchar(word)))
  word_chars <- strsplit(padded_word, "")[[1]]
  word_split <- split(word_chars, rep(1:n, 1:n))
  
  formatted_lines <- map(word_split, ~str_pad(paste0(.x, collapse = " "), n * 2 - 1, side = "both")) %>%
    map(~strsplit(.x, "")) %>%
    unlist() %>%
    matrix(nrow = n, ncol = n * 2 - 1, byrow = TRUE) %>%
    replace(., . == " ", NA) %>%
    as.data.frame() %>% 
    filter(!if_all(everything(), is.na)) %>%  
    as.matrix()
  
  formatted_lines
}
words = c("thu", "moon", "excel", "skyjacking", "embezzlements")

all.equal(draw_triangle_from_word(words[1]), test1, check.attributes = FALSE) # TRUE
all.equal(draw_triangle_from_word(words[2]), test2, check.attributes = FALSE) # TRUE
all.equal(draw_triangle_from_word(words[3]), test3, check.attributes = FALSE) # TRUE
all.equal(draw_triangle_from_word(words[4]), test4, check.attributes = FALSE) # TRUE
all.equal(draw_triangle_from_word(words[5]), test5, check.attributes = FALSE) # TRUE

