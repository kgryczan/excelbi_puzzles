library(tidyverse)
library(readxl)

path = "Excel/800-899/826/826 Align Cities.xlsx"
input = read_excel(path, range = "A1:E19")
test  = read_excel(path, range = "G1:K19")

inp_set = input %>% summarise(across(everything(), ~sum(!is.na(.)))) %>% unlist()
cities = sort(unique(unlist(input)))
starts = cumsum(c(1, head(inp_set, -1)))
cols = map2(starts, inp_set, ~c(cities[.x:(.x + .y - 1)], rep(NA, 18 - .y)))
result = bind_cols(set_names(cols, names(input)))

identical(result, test) # TRUE
