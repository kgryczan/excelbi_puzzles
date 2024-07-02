library(tidyverse)
library(readxl)

path = "Excel/490 - Fill Down.xlsx"

input = read_xlsx(path, range = "A1:B18")
test  = read_xlsx(path, range = "C1:C18")

result = input %>%
  fill(`Level 1`, .direction = "down") %>%
  group_by(group = cumsum(`Level 1` != lag(`Level 1`, default = first(`Level 1`))) + 1) %>%
  mutate(
    nr1 = row_number(),
    L2 = !is.na(`Level 2`) & nr1 != 1,
    L2_n2 = ifelse(L2, cumsum(L2), 0),
    `Answer Expected` = as.numeric(paste0(group, ".", L2_n2))
  ) %>%
  ungroup() %>%
  select(`Answer Expected`)

identical(result, test) 
#> [1] TRUE