library(tidyverse)
library(readxl)

path = "Excel/567  ASCII House.xlsx"
test  = read_excel(path, range = "C2:Q18", col_names = F) %>%
  replace(is.na(.), "") %>% as.matrix()

M = matrix("", nrow = 17, ncol = 15)

for (i in 1:7) {
  M[i, (8 - i + 1):(8 + i - 1)] = "#"
}
M[17, ] = "#"
for (i in 8:16) {
  M[i, c(2, 14)] = "#"
}
M[16, -c(1, 15)] = "#"
M[9:11, c(4,6)] = "#"
M[c(9, 11), 5] = "#"
M[9:16, 9] = "#"
M[9, 10:11] = "#"
M[9:16, 12] = "#"
 
all.equal(M, test, check.attributes = F) # TRUE
as.data.frame(M)











