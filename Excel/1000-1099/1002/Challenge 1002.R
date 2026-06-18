library(tidyverse)
library(readxl)

path <- "1000-1099/1002/1002 Symmetric Triangles.xlsx"
input1 = 5
input2 = 12
test1 <- read_excel(path, range = "A2:C6", col_names = FALSE) %>%
  as.matrix() %>%
  replace(is.na(.), "")
test2 <- read_excel(path, range = "A9:F20", col_names = FALSE) %>%
  as.matrix() %>%
  replace(is.na(.), "")
generate_symmetric_triangle <- function(n) {
  stopifnot(is.numeric(n), length(n) == 1, n > 0, n %% 1 == 0)
  max_cols <- ceiling(n / 2)
  half <- seq_len(n %/% 2)
  widths <- c(
    if (n %% 2 == 0) {
      c(half, rev(half))
    } else {
      c(seq_len(max_cols), rev(seq_len(max_cols - 1)))
    }
  )
  matrix("", nrow = n, ncol = max_cols) %>%
    {
      next_idx <- 1
      for (i in seq_len(n)) {
        .[i, seq_len(widths[i])] <- LETTERS[
          ((seq(next_idx, length.out = widths[i]) - 1) %% 26) + 1
        ]
        next_idx <- next_idx + widths[i]
      }
      .
    }
}
all(generate_symmetric_triangle(input1) == test1) #> TRUE
all(generate_symmetric_triangle(input2) == test2) #> TRUE
