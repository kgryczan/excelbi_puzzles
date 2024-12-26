library(tidyverse)
library(readxl)

path = "Excel/616 Draw a Christmas Tree.xlsx"
test  = read_excel(path, range = "A1:O19", col_names = FALSE) %>% as.matrix() %>% 
  replace(is.na(.), "")


M = matrix("", 19, 15)

middle = (ncol(M) + 1) / 2

M[1, middle] = "*"
for (i in 2:8) {
  M[i, middle + c(-i + 1, i - 1)] = "*"
}
M[8,] = "*"

M[9, middle] = "*"
for (i in 10:16) {
  M[i, middle + c(-i + 9, i - 9)] = "*"
}
M[16,] = "*"

M[17, middle + c(-1, 1)] = "|"
M[18, middle + -2:2] = "-"

M[19, middle + c(-3, 3)] = c("/", "\\")
M[19, middle + -2:2] = "_"

M[c(2, 10), middle] = "1"

for (i in c(3:7, 11:15)) {
  M[i, middle - i + ifelse(i < 10, 2, 10)] = "1"
  M[i, middle + i - ifelse(i < 10, 2, 10)] = "1"
}

for (i in c(3:7, 11:15)) {
  M[i, middle - i + ifelse(i < 10, 3, 11)] = "2"
  M[i, middle + i - ifelse(i < 10, 3, 11)] = "2"
}

for (i in c(4:7, 12:15)) {
  M[i, middle - i + ifelse(i < 10, 4, 12)] = "3"
  M[i, middle + i - ifelse(i < 10, 4, 12)] = "3"
}

for (i in c(5:7, 13:15)) {
  M[i, middle - i + ifelse(i < 10, 5, 13)] = "4"
  M[i, middle + i - ifelse(i < 10, 5, 13)] = "4"
}

for (i in c(6:7, 14:15)) {
  M[i, middle - i + ifelse(i < 10, 6, 14)] = "5"
  M[i, middle + i - ifelse(i < 10, 6, 14)] = "5"
}

for (i in 7:7) {
  M[i, middle - i + 7] = "6"
  M[i, middle + i - 7] = "6"
}

for (i in 15:15) {
  M[i, middle - i + 15] = "6"
  M[i, middle + i - 15] = "6"
}


all.equal(M, test, check.attributes = FALSE)
# [1] TRUE