library(tidyverse)
library(readxl)

path = "Excel/634 Array Equality.xlsx"
input = read_excel(path, range = "A2:B10")
test  = read_excel(path, range = "D2:E7")

result = input %>%
  mutate(set_array1 = map(Array1, ~ sort(unique(strsplit(.x, ",")[[1]]))),
         set_array2 = map(Array2, ~ sort(unique(strsplit(.x, ",")[[1]])))) %>%
  mutate(result = map2(set_array1, set_array2, ~ .x %>% setequal(.y))) %>%
  filter(result == TRUE) %>%
  select(Array1, Array2)

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE