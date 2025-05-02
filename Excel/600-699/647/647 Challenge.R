library(tidyverse)
library(readxl)

path <- "Excel/647 Alphabets Pattern Generation.xlsx"
test <- read_excel(path, range = "R2C1:R27C50", col_names = FALSE) %>% 
    as.matrix() %>% replace(is.na(.), "")

generate_matrix <- function(rows = 26, cols = 50) {
    mat <- matrix("", nrow = rows, ncol = cols)
    mat[, 1] <- "A"
    
    for (i in 2:cols) {
        if (i %% 2 == 0) {
            mat[(i / 2 + 1):rows, i] <- LETTERS[(i / 2 + 1):rows]
        } else {
            start_row <- (i + 1) / 2 + 1
            if (start_row <= rows) {
                mat[start_row:rows, i] <- LETTERS[start_row - 1]
            }
        }
    }
    return(mat)
}

result <- generate_matrix(26, 50)
all.equal(result, test, check.attributes = FALSE)
# [1] TRUE
