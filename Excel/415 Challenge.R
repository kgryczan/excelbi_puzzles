library(tidyverse)
library(readxl)

test = read_excel("Excel/415 Triangular Cyclops Numbers.xlsx", range = "A1:A101" )

range = 1:1e7

is_triangular <- function(x) {
  n <- (-1 + sqrt(1 + 8 * x)) / 2
  n == floor(n)
}

r = data.frame(n = range) %>%
  mutate(nchar = nchar(n)) %>%
  filter(nchar %% 2 == 1) %>%
  mutate(zeroes = str_count(n, "0"), 
         central = substr(n, nchar/2+1, nchar/2+1)) %>%
  filter(zeroes == 1, 
         central == "0") %>%
  mutate(triangular = is_triangular(n)) %>%
  filter(triangular == TRUE) %>%
  head(100) %>%
  mutate(n = as.numeric(n))

identical(r$n, test$`Expect Answer`)
# [1] TRUE
