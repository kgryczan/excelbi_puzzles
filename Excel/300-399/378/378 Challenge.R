library(tidyverse)
library(readxl)

input = read_excel("Excel/378 Split When Sum of LH is GT RH.xlsx", range = "A1:A10")
test  = read_excel("Excel/378 Split When Sum of LH is GT RH.xlsx", range = "B1:C10") %>%
  janitor::clean_names() %>%
  select(cut_1test = 1, cut_2test = 2)
  

find_cut_point = function(n_vec) {
  vec = str_split(n_vec, ", ")[[1]] %>% as.numeric()
  n = length(vec)
  for (i in 1:n) {
    if (sum(vec[1:i]) > sum(vec[(i + 1):n])) {
      return(i)
    }
  }
}

cut_vector = function(n_vec) {
  vec = str_split(n_vec, ", ")[[1]] %>% as.numeric()
  cut_point = find_cut_point(n_vec)
  p1 = vec[1:cut_point] %>% str_c(collapse = ", ")
  p2 = vec[(cut_point + 1):length(vec)] %>% str_c(collapse = ", ")
  return(list(p1, p2))
}


result = input %>%
  mutate(cut = map(Numbers, cut_vector)) %>%
  unnest_wider(cut, names_sep = "_") %>%
  bind_cols(test) %>%
  mutate(check_cut1 = cut_1 == cut_1test,
         check_cut2 = cut_2 == cut_2test)

