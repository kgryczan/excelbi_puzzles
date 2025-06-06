library(tidyverse)
library(readxl)

path = "Excel/700-799/733/733.xlsx"
input = read_excel(path, range = "A1:B11")
test = read_excel(path, range = "C1:C11")

rotate_string = function(x, n) {
  len = nchar(x)
  n = (n %% len)
  if (n == 0) return(x)
  paste0(substr(x, len - n + 1, len), substr(x, 1, len - n))
}

result = input %>%
  mutate(
    Rotation = map_dbl(str_split(Rotation, ", "), ~ sum(as.numeric(.)))
  ) %>%
  mutate(`Answer Expected` = map2_chr(Words, Rotation, ~ rotate_string(.x, .y)))

all.equal(result$`Answer Expected`, test$`Answer Expected`)
# [1] TRUE
