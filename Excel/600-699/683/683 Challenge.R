library(tidyverse)
library(readxl)

path = "Excel/683 Find Numbers in a Grid.xlsx"
input1 = read_excel(path, range = "C3:L12", col_names = FALSE) %>% as.matrix()
input2 = read_excel(path, range = "N2:N12")
test  = read_excel(path, range = "O2:O12") %>% mutate(Value = as.numeric(Value))

result = input2 %>%
  mutate(
    num = as.character(Number),
    n = nchar(num), 
    mod = n %% 2,
    row = as.numeric(ifelse(mod == 0, str_sub(num, n-1, n-1), str_sub(num, n, n)))+1,
    col = as.numeric(ifelse(mod == 0, str_sub(num, n, n), str_sub(num, n-1, n-1)))+1) %>%
  mutate(value =map2_dbl(row, col, ~input1[.x, .y])) %>%
  select(value)

all.equal(result, test, check.attributes = FALSE)

# [1] TRUE