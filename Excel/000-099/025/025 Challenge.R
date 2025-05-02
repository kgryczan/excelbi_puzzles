library(tidyverse)
library(readxl)

path = "Excel/025 Magic Square.xlsx"
input1 = read_excel(path, range = "B2:D4", col_names = FALSE) %>% as.matrix()
input2 = read_excel(path, range = "B6:D8", col_names = FALSE) %>% as.matrix()
input3 = read_excel(path, range = "B10:D12", col_names = FALSE) %>% as.matrix()
input4 = read_excel(path, range = "B14:D16", col_names = FALSE) %>% as.matrix()

check_magicness <- function(input) {
  all(
    sort(input) == 1:9,                
    rowSums(input) == 15,              
    colSums(input) == 15,             
    sum(diag(input)) == 15,            
    sum(diag(t(input))) == 15          
  )
}

check_magicness(input1) # TRUE
check_magicness(input2) # FALSE
check_magicness(input3) # TRUE
check_magicness(input4) # FALSE
