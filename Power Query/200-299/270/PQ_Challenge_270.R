library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_270.xlsx"
input = read_excel(path, range = "A1:D11") %>% as.matrix()
test  = read_excel(path, range = "F1:I11") %>% as.matrix()

output = map_dfc(1:nrow(input), ~input[.x, (seq_len(ncol(input)) + .x - 2) %% ncol(input) + 1]) %>% t()

all.equal(output, test, check.attributes = FALSE)
#> [1] TRUE