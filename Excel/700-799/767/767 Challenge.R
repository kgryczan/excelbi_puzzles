library(tidyverse)
library(readxl)
library(gtools)

path = "Excel/700-799/767/767 Distinct Digits.xlsx"
input = read_excel(path, range = "A1:B6")
test  = read_excel(path, range = "C1:E6") %>% 
  mutate(across(everything(), as.integer))

distinct_digit_numbers = function(from, to) {
  rng = nchar(as.character(from)):nchar(as.character(to))
  pool = 0:9
  all_valid = map_dfr(rng, function(k) {
    map_dfr(setdiff(pool, 0), function(h) {
      tail_pool = setdiff(pool, h)
      tail_perms = permutations(length(tail_pool), k - 1, tail_pool)
      tibble(n = as.integer(paste0(h, apply(tail_perms, 1, paste0, collapse = ""))))
    })
  }) %>% filter(n >= from, n <= to)
  nvec = all_valid$n
  tibble(
    Count = length(nvec),
    Min = min(nvec, na.rm = TRUE),
    Max = max(nvec, na.rm = TRUE)
  )
}

result = map2_dfr(input$From, input$To, distinct_digit_numbers) 
all.equal(result, test) 
# > [1] TRUE  