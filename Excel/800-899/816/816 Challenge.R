library(tidyverse)
library(readxl)
library(combinat)

path = "Excel/800-899/816/816 Penholodigial Numbers.xlsx"
test  = read_excel(path, range = "A1:A31", col_types = "numeric") %>% pull()

squares_df = (ceiling(sqrt(123456789)):floor(sqrt(987654321)))^2
squares_df = squares_df[map_lgl(squares_df, ~ setequal(as.integer(str_split(.x, "", simplify = TRUE)), 1:9))]
all.equal(squares_df, test)
# [1] TRUE
