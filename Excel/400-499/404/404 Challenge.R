library(tidyverse)
library(readxl)

test = read_excel("Excel/404 Generate US ASCII Flag.xlsx", range = "A1:AL15",
                  col_names = FALSE, .name_repair = "unique") %>% as.matrix() 
# remove attribute "names" from matrix
attr(test, "dimnames") = NULL

result = matrix(NA, nrow = 15, ncol = 38)

result[1,] = "-"
result[15,] = "-"
result[2:14,1] = "|"
result[2:14,38] = "|"

for (i in 2:14){
  for (j in 2:37){
    if (i %% 2 == 0){
      result[i,j] = 0
    } else {
      result[i,j] = "1"
    }
  }
}

for (i in 2:10){
  for (j in 2:12){
    if (i %% 2 == 0){
      if (j %% 2 == 0){
        result[i,j] = "*"
      } else {
        result[i,j] = NA
      }
    } else {
      if (j %% 2 == 0){
        result[i,j] = NA
      } else {
        result[i,j] = "*"
      }
    }
  }
}

identical(result, test)
# [1] TRUE
