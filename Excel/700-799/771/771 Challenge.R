library(tidyverse)
library(readxl)

path = "Excel/700-799/771/771 Split and Align.xlsx"
input = read_excel(path, range = "A1:A11")
test  = read_excel(path, range = "B1:B46")

cut_progressive_chunks = function(x) {
  n = str_length(x)
  k = floor((sqrt(1 + 8 * n) - 1) / 2)
  lengths = 1:k
  starts = cumsum(c(1, head(lengths, -1)))
  ends = cumsum(lengths)
  map2_chr(starts, ends, ~ str_sub(x, .x, .y))
}

result = input %>%
  rowwise() %>%
  mutate(chunks = list(cut_progressive_chunks(Strings))) %>%
  unnest(chunks)

all.equal(result$chunks, test$`Answer Expected`, check.attributes = FALSE)
# > [1] TRUE