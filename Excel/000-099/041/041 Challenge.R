library(tidyverse)
library(readxl)

path = "Excel/041 Random Team Allocation.xlsx"
input = read_excel(path, range = "A1:A18")

shuffled_input = input %>% sample_n(nrow(input))
teams <- lapply(split(shuffled_input[1:12, ], rep(1:4, each = 3)), rbind, NA, NA)
reserve = shuffled_input[13:17,]

output = cbind(do.call(cbind, teams), reserve)
output
