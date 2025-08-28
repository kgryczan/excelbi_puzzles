library(tidyverse)
library(readxl)

path = "Excel/700-799/792/792 Sorting as per Last Letter.xlsx"
input = read_excel(path, range = "A1:A27") %>% pull()
test  = read_excel(path, range = "B1:B27") %>% pull()

chain_sort = function(words){
  seed = "Apple"
  pool = words[words != seed]
  out = seed
  while(length(pool)){
    last = tolower(str_sub(last(out), -1))
    pool_tbl = tibble(word = pool, first = str_sub(tolower(pool), 1, 1))
    abc = c(letters[match(last, letters):26], letters[1:(match(last, letters)-1)])
    next_word = pool_tbl %>%
      mutate(order = match(first, abc)) %>%
      filter(!is.na(order)) %>%
      arrange(order) %>%
      slice(1) %>%
      pull(word)
    out = c(out, next_word)
    pool = setdiff(pool, next_word)
  }
  out
}
result = chain_sort(input)
all(result == test)
# > [1] TRUE
