library(tidyverse)
library(readxl)

path = "Excel/177 Same Occurrences.xlsx"
input = read_excel(path, range = "A1:B7")
test  = read_excel(path, range = "C1:C7")

result = input %>%
  mutate(rn = row_number()) %>%
  mutate(Number1 = strsplit(as.character(Number1), ""),
         Number2 = strsplit(as.character(Number2), "")) %>%
  mutate(Number1 = map(Number1, ~table(.x) %>% discard(~. == 1) %>% as.data.frame() %>% rownames_to_column()),
         Number2 = map(Number2, ~table(.x) %>% discard(~. == 1) %>% as.data.frame() %>% rownames_to_column())) %>%
  mutate(same_occurrences = map2(Number1, Number2, ~identical(.x, .y))) %>%
  mutate(num = map_chr(Number1, ~.x$.x %>% paste(collapse = ", ")),
         num2 = map_chr(Number2, ~.x$rowname %>% paste(collapse = ", "))) %>%
  mutate(ncol = map_dbl(Number1, ~ncol(.x))) %>%
  mutate(result = case_when(same_occurrences == T & ncol == 2 ~ num2,
                            same_occurrences == T & ncol == 3 ~ num,
                            TRUE ~ NA_character_))

all.equal(result$result, test$`Expected Result`, check.attributes = FALSE)
#> [1] TRUE