library(tidyverse)
library(readxl)

path = "Excel/661 Matrix Transformation.xlsx"
M1 = read_excel(path, range = "B2:F6", col_names = FALSE) %>% as.matrix()
M2 = read_excel(path, range = "I2:M6", col_names = FALSE) %>% as.matrix()
M3 = read_excel(path, range = "P2:T6", col_names = FALSE) %>% as.matrix()

M1_values = c(M1[1,], M1[2,], M1[3,], M1[4,], M1[5,]) %>% as.vector()

MT = matrix(NA, nrow = nrow(M1), ncol = ncol(M1))

fill_mrow <- function(MT, M1_values, row_index) {
  empty_cells = which(is.na(MT[row_index,]))
  max_value = max(MT, na.rm = TRUE)
  M1_values[which(M1_values > max_value)][1:length(empty_cells)]
  MT[row_index,empty_cells] = M1_values[which(M1_values > max_value)][1:length(empty_cells)]
  return(MT)
}

fill_mcol <- function(MT, M1_values, col_index) {
  empty_cells = which(is.na(MT[,col_index]))
  max_value = max(MT, na.rm = TRUE)
  M1_values[which(M1_values > max_value)][1:length(empty_cells)]
  MT[empty_cells,col_index] = M1_values[which(M1_values > max_value)][1:length(empty_cells)]
  return(MT)
}

walk(1:5, ~ {
  MT <<- fill_mrow(MT, M1_values, .x)
  MT <<- fill_mcol(MT, M1_values, .x)
})

all(MT == M2) 
#> [1] TRUE

# ---- reverse transformation ----


extract_alternating <- function(M) {
  result <- accumulate(1:min(nrow(M), ncol(M)), function(MT, i) {
    if (nrow(MT) == 0 || ncol(MT) == 0) return(MT)
    
    assign(paste0("M2_", i, "r"), MT[1, , drop = FALSE], envir = .GlobalEnv)
    MT <- MT[-1, , drop = FALSE]
    
    if (nrow(MT) > 0) {
      assign(paste0("M2_", i, "c"), MT[, 1, drop = FALSE], envir = .GlobalEnv)
      MT <- MT[, -1, drop = FALSE]
    }
    
    return(MT)
  }, .init = M)[-1] 
  return(result)
}

M2T <- extract_alternating(M2)

M2T = c(M2_1r, M2_1c, M2_2r, M2_2c, M2_3r, M2_3c, M2_4r, M2_4c, M2_5r) 
M2T = matrix(M2T, nrow = 5, ncol = 5, byrow = TRUE)
all(M2T == M3)
#> [1] TRUE