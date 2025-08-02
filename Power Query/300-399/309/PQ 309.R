library(tidyverse)
library(readxl)

path = "Power Query/300-399/309/PQ_Challenge_309.xlsx"
input = read_excel(path, range = "A1:A20")
test  = read_excel(path, range = "C1:D6")

group_consecutive_under_limit = function(x, limit = 50) {
  group <- 1
  subtotal <- 0
  
  map2_dbl(x, seq_along(x), function(val, i) {
    if (subtotal + val > limit) {
      group <<- group + 1
      subtotal <<- val
    } else {
      subtotal <<- subtotal + val
    }
    group
  })
}

result = input %>%
  mutate(Groups = paste0("Group",group_consecutive_under_limit(Values, 50))) %>%
  summarise(Values = paste(Values, collapse = ", "), .by = Groups)

all.equal(result, test)
# > TRUE