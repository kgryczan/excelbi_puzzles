library(tidyverse)
library(readxl)

path = "Excel/611 Find Max N Digit Numbers in the Grid.xlsx"
input = read_excel(path, range = "A3:F8", col_names = FALSE) %>% as.matrix()
test  = read_excel(path, range = "H2:I8")

get_substrings <- function(string, length) {
  n <- nchar(string)
  if (length > n) return(character(0))
  map_chr(1:(n - length + 1), ~ str_sub(string, .x, .x + length - 1))
}

result = input %>% t() %>% 
  rbind(input) %>%
  as_tibble() %>%
  unite("con", 1:6, sep = "") %>%
  mutate(s1 = map(con, ~ get_substrings(.x, 1)),
         s2 = map(con, ~ get_substrings(.x, 2)),
         s3 = map(con, ~ get_substrings(.x, 3)),
         s4 = map(con, ~ get_substrings(.x, 4)),
         s5 = map(con, ~ get_substrings(.x, 5)),
         s6 = map(con, ~ get_substrings(.x, 6))) %>%
  select(-con) %>%
  pivot_longer(cols = everything(), names_to = "length", values_to = "substrings") %>%
  unnest(substrings) %>%
  summarise(max = max(as.numeric(substrings)), .by = length)
  
all.equal(result$max, test$`Max Number`)
#> [1] TRUE