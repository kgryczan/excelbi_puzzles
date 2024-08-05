library(tidyverse)
library(readxl)

path = "Excel/514 Sub Grid Maximum Sum.xlsx"
input = read_excel(path, range = "B2:F6", col_names = F) %>% as.matrix()
test  = read_excel(path, range = "H1:H4") %>% arrange(`Answer Expected`)

indices = expand.grid(i = 1:(nrow(input) - 1), j = 1:(ncol(input) - 1))
results = indices %>%
  pmap(function(i, j) {
    sub_mat = input[i:(i + 1), j:(j + 1)]
    list(matrix = sub_mat, sum = sum(sub_mat, na.rm = TRUE))
  })
max_sum = max(map_dbl(results, "sum"))
max_subs = keep(results, ~ .x$sum == max_sum)
max_subs_str = map_chr(max_subs, ~ paste(apply(.x$matrix, 1, paste, collapse = ", "), collapse = " ; ")) %>%
  tibble(`Answer Expected` = .) %>%
  arrange(`Answer Expected`)

identical(max_subs_str, test)
#> [1] TRUE