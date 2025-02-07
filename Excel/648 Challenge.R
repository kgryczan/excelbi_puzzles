library(tidyverse)
library(readxl)

path = "Excel/648 Both Perfect Square and Perfect Cube.xlsx"
test  = read_excel(path, range = "A1:A21")

result = data.frame(`Answer Expected` = 1:20) %>% map_dfr(., ~.x ^ (2 * 3))

all.equal(result$Answer.Expected, test$`Answer Expected`)
#> [1] TRUE