library(tidyverse)
library(readxl)
library(slider)

path = "Excel/700-799/723/723 Maximum for 3 Consecutive Cells in a Row.xlsx"
input = read_excel(path, range = "A2:J11", col_names = FALSE) %>% as.matrix()
test = read_excel(path, range = "L1:L2") %>% pull()

max_consecutive_values = function(input) {
  rows = split(input, row(input))
  triplets = map(rows, function(row) {
    windows = slide(row, ~.x, .before = 0, .after = 2, .complete = TRUE)
    windows = keep(windows, ~ length(.x) == 3)
    best_idx = which.max(map_dbl(windows, sum))
    windows[[best_idx]]
  })
  max_triplet = map_dbl(triplets, sum) %>% which.max()
  return(triplets[[max_triplet]] %>% paste(collapse = ", "))
}

result = max_consecutive_values(input)

all.equal(result, test)
# TRUE
