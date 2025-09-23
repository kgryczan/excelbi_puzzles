library(tidyverse)
library(readxl)

path = "Excel/800-899/810/810 Align Data.xlsx"

input = read_excel(path, range = "A2:F9", col_names = FALSE) %>% as.matrix()
test  = read_excel(path, range = "H2:I10", col_names = c("Left", "Right"))

x = input %>% t() %>% as.vector() %>% discard(is.na)
pairs = map2_chr(
    keep(x, ~ str_detect(.x, "^[A-Za-z]+$")),
    keep(x, ~ str_detect(.x, "^[0-9]+$")),
    ~ str_c(.x, .y, sep = "-")
)
n = length(pairs)
h = ceiling(n/2)
bent = tibble(Left = pairs[1:h], Right = c(rev(pairs)[1:(h-1)], NA))
all_equal(bent, test)
# TRUE
