library(dplyr)
library(purrr)

create_triangular_dataframe <- function(letters) {
  n <- max(which((1:10 * (1:10 + 1)) / 2 <= length(letters)))
  num_rows <- n + 1
  num_cols <- n * 2 + 1
  
  df <- data.frame(matrix("", nrow = num_rows, ncol = num_cols))
  
  letters_idx <- 1
  
  fill_row <- function(row_num, num_letters) {
    start_col <- (num_cols - (2 * num_letters - 1)) %/% 2 + 1
    df[row_num, seq(start_col, by = 2, length.out = num_letters)] <<- letters[letters_idx:(letters_idx + num_letters - 1)]
    letters_idx <<- letters_idx + num_letters
  }
  
  walk(1:n, ~ fill_row(.x, .x))
  
  fill_row(num_rows, length(letters) - (n * (n + 1)) / 2)

  colnames(df) <- LETTERS[1:ncol(df)]  
  print(df, row.names = FALSE)
}

df = create_triangular_dataframe(LETTERS)
