library(tidyverse)
library(readxl)

input = read_excel("Excel/443 Birds Search.xlsx", range = "B2:K11", col_names = FALSE)
list  = read_excel("Excel/443 Birds Search.xlsx", range = "M1:M12")
test  = read_excel("Excel/443 Birds Search.xlsx", range = "O2:X11", col_names = FALSE)
colnames(test) = c(1:10)

find_bird = function(grid, bird_name) {
  grid = unite(grid, col = "all", everything(), sep = "") %>%
    mutate(nrow = row_number()) %>%
    mutate(coords = str_locate(all, bird_name)) %>%
    na.omit() %>%
    select(-all)
  return(grid)
}

coords = map_dfr(list$Birds, ~find_bird(input, .x)) %>%
  mutate(start = coords[,1], end = coords[,2]) %>%
  select(-coords) %>%
  rowwise() %>%
  mutate(cols = list(seq(start, end))) %>%
  select(-start, -end) %>%
  unnest(cols) %>%
  mutate(check = T)

input2 = input %>% 
  mutate(nrow = row_number()) %>%
  pivot_longer(cols = -nrow, names_to = "col", values_to = "value") %>%
  mutate(col = str_extract(col, "\\d+") %>% as.numeric()) %>%
  left_join(coords, by = c("nrow" = "nrow", "col" = "cols")) %>%
  mutate(check = ifelse(is.na(check), F, T),
         value = ifelse(check, value, 'x')) %>%
  select(-check) %>%
  pivot_wider(names_from = col, values_from = value) %>%
  select(-nrow)

identical(input2, test)
# [1] TRUE
