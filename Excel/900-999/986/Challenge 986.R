library(tidyverse)
library(readxl)

path <- "900-999/986/986 Fill the Diagonals of Squares.xlsx"

read_trimmed <- function(range) {
  read_excel(path, range = range, col_names = FALSE) %>%
    as.matrix() %>%
    {
      x <- .
      x[is.na(x)] <- ""
      x
    } %>%
    trimws()
}

input1 <- read_trimmed("B2:F6")
input2 <- read_trimmed("B10:D12")
input3 <- read_trimmed("B15:H21")
test1 <- read_trimmed("L2:P6")
test2 <- read_trimmed("L10:N12")
test3 <- read_trimmed("L15:R21") %>% str_replace_all(" ", "")

fill_diagonal <- function(mat) {
  n <- nrow(mat)
  m <- (n + 1) / 2
  nums <- \(x) str_extract_all(x, "\\d+") %>% unlist() %>% as.integer()
  d1 <- cbind(1:n, 1:n)
  d2 <- cbind(1:n, n:1)
  center <- nums(mat[m, m])
  get_diag_value <- \(diag_indices) {
    setdiff(nums(mat[diag_indices]), center) %>%
      {
        if (length(.)) .[1] else center[1]
      }
  }
  mat[d1] <- get_diag_value(d1)
  mat[d2] <- get_diag_value(d2)
  mat[m, m] <- paste(sort(unique(c(mat[m[1], m[1]], center))), collapse = ",")
  mat
}
all(fill_diagonal(input1) == test1) #> TRUE
all(fill_diagonal(input2) == test2) #> TRUE
all(fill_diagonal(input3) == test3) #> TRUE
