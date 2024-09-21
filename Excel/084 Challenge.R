library(tidyverse)
library(readxl)

path = "Excel/084 Pascal Case to Snake Case.xlsx"
input = read_excel(path, range = "A1:A8")
test  = read_excel(path, range = "B1:B8")

pascal_to_snake = function(x) {
  x = str_replace_all(x, "([A-Z])", "_\\1")
  x = str_remove(x, "^_")
  return(x)
}

result = input %>%
  mutate(`Snake Case` = map_chr(`Pascal Case`, pascal_to_snake))

identical(result$`Snake Case`, test$`Snake Case`)
#> [1] TRUE