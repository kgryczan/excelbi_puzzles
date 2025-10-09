library(tidyverse)
library(readxl)

get_list = . %>% unlist() %>% as.integer() %>% na.omit()

path = "Excel/800-899/822/822 Largest N Digit Numbers in Grids.xlsx"
input1 = read_excel(path, range = "A3:C5", col_names = FALSE) %>% as.matrix()
test1  = read_excel(path, range = "J3:M3", col_names = FALSE) %>% get_list()
input2 = read_excel(path, range = "A7:D10", col_names = FALSE) %>% as.matrix()
test2 = read_excel(path, range = "J7:M7", col_names = FALSE) %>% get_list()
input3 = read_excel(path, range = "A12:E16", col_names = FALSE) %>% as.matrix()
test3  = read_excel(path, range = "J12:M12", col_names = FALSE) %>% get_list()

roll_max_num <- function(v, n) {
  if (length(v) < n) return(-Inf)
  map_int(1:(length(v) - n + 1), ~ as.integer(paste0(v[.x:(.x + n - 1)], collapse = ""))) %>% max()
}

max_for_N <- function(mat, n) {
  rows <- asplit(mat, 1) %>% map_int(roll_max_num, n)
  cols <- asplit(mat, 2) %>% map_int(roll_max_num, n)
  max(c(rows, cols))
}

result1 = map_int(2:nrow(input1), ~ max_for_N(input1, .x))
result2 = map_int(2:nrow(input2), ~ max_for_N(input2, .x))
result3 = map_int(2:nrow(input3), ~ max_for_N(input3, .x))

all.equal(result1, test1, check.attributes = FALSE) # one different than provided
all.equal(result2, test2, check.attributes = FALSE) # all correct
all.equal(result3, test3, check.attributes = FALSE) # two different than provided
