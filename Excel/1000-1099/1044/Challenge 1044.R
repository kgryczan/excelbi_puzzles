library(tidyverse)
library(readxl)

path <- "1000-1099/1044/1044 Lexographical Smallest Rotation.xlsx"
input <- read_excel(path, range = "A1:A11")
test <- read_excel(path, range = "B1:B11")

rotate <- function(x, n) {
  paste0(substr(x, n + 1, nchar(x)), substr(x, 1, n))
}

min_rotation <- function(x) {
  map_chr(0:(str_length(x) - 1), ~ rotate(x, .x)) %>%
    min()
}

result <- input %>%
  mutate(rn = row_number()) %>%
  separate_longer_delim(Data, " ") %>%
  mutate(min_rotation = map_chr(Data, min_rotation)) %>%
  summarise(result = str_c(sort(min_rotation), collapse = " "), .by = rn)

all.equal(test[['Answer Expected']], result[['result']])
# TRUE
