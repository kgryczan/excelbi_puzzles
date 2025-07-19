  library(tidyverse)
  library(readxl)
  
  path = "Excel/700-799/763/763 Alphabets Staircase3.xlsx"
  test  = read_excel(path, range = "A2:AA27", col_names = FALSE) %>% as.matrix()
  input_matrix = matrix(NA_character_, nrow = 26, ncol = 27)
  
  for (i in 1:26) {
    input_matrix[i, i:(i + 1)] = LETTERS[i]
    if (i %% 2 == 0) input_matrix[i - 1, i + 1] = LETTERS[i]
  }
  
  all(input_matrix == test, na.rm = TRUE)
  # > [1] TRUE
