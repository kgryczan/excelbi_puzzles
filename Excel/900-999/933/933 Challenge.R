library(tidyverse)
library(readxl)

path <- "900-999/933/933 Number Pattern.xlsx"
input1 <- read_excel(path, sheet = 2, range = "A2", col_names = F) %>% pull()
test1 <- read_excel(path, sheet = 2, range = "C2:G4", col_names = F) %>%
  as.matrix() %>%
  replace(is.na(.), 0)
input2 <- read_excel(path, sheet = 2, range = "A6", col_names = F) %>% pull()
test2 <- read_excel(path, sheet = 2, range = "C6:I9", col_names = F) %>%
  as.matrix() %>%
  replace(is.na(.), 0)
input3 <- read_excel(path, sheet = 2, range = "A11", col_names = F) %>% pull()
test3 <- read_excel(path, sheet = 2, range = "C11:Q18", col_names = F) %>%
  as.matrix() %>%
  replace(is.na(.), 0)

fill_matrix <- function(n) {
  mat <- matrix(data = 0, nrow = n, ncol = n * 2 - 1)
  for (r in n:1) {
    t_val <- (r * (r + 1)) / 2
    max_offset <- n - 1
    min_offset <- n - r

    for (offset in min_offset:max_offset) {
      val <- t_val - (offset - min_offset)
      mat[r, n - offset] <- val
      mat[r, n + offset] <- val
    }
  }
  return(mat)
}

all.equal(test1, fill_matrix(input1), check.attributes = F) # TRUE
all.equal(test2, fill_matrix(input2), check.attributes = F) # TRUE
all.equal(test3, fill_matrix(input3), check.attributes = F) # TRUE
