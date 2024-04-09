library(tidyverse)
library(readxl)

shift_left <- function(mat, shift_size) {
  n_cols <- ncol(mat)
  tibble_mat <- as_tibble(mat)
  shifted_df <- tibble_mat %>%
    pmap_dfr(., ~{
      row_values <- c(...)
      shifted_values <- c(row_values[(shift_size + 1):length(row_values)], rep(NA, shift_size))
      return(as_tibble(t(shifted_values)))
    })
  as.matrix(shifted_df)
}


for (i in 26:1) {
  M <- matrix(NA, nrow = 1, ncol = 52)
  M[1, 1:i] <- 1:i
  M <- t(apply(M, 1, rev))
  M = shift_left(M, 53-2*i)
  M[!is.na(M)] <- LETTERS[M[!is.na(M)]]
  
  if (i == 26){
    M_final <- M
  } else {
    M_final <- rbind(M_final, M)
  }
}

mf_df = M_final %>% as.data.frame()

writexl::write_xlsx(mf_df, "430 Excel solution.xlsx")



