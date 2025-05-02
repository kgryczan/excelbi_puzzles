library(tidyverse)
library(readxl)

path = "Excel/213 Identical Row Column.xlsx"
input1 = read_excel(path, range = "A2:D5", col_names = F) %>% as.matrix()
input2 = read_excel(path, range = "A7:E11", col_names = F) %>% as.matrix()
input3 = read_excel(path, range = "A13:C15", col_names = F) %>% as.matrix()
input4 = read_excel(path, range = "A17:E21", col_names = F) %>% as.matrix()
input5 = read_excel(path, range = "A23:D26", col_names = F) %>% as.matrix()
ans1 = 1
ans2 = 0
ans3 = 2
ans4 = 2
ans5 = 4

check = function(matrix) {
  rows = apply(matrix, 1, function(x) paste(x, collapse = " "))
  cols = apply(matrix, 2, function(x) paste(x, collapse = " "))

  calc = crossing(rows, cols) %>%
    mutate(n =length(rows)) %>%
    mutate(is_the_same = rows == cols) %>%
  filter(is_the_same)
  return(calc)
}

check(input4)
check(input1)
check(input2)
check(input3)
check(input5)

