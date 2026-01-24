library(tidyverse)
library(readxl)

path <- "Excel/800-899/896/896 Color Mixing.xlsx"
input <- read_excel(path, range = "A1:A20")
test <- read_excel(path, range = "B1:B20")

mix <- function(x, y) {
  if (x == y) x else setdiff(c("r", "b", "y"), c(x, y))
}

result <- input %>%
  mutate(
    `Answer Expected` = map_chr(
      `Color Codes`,
      ~ Reduce(mix, str_split(.x, "")[[1]])
    )
  ) %>%
  select(`Answer Expected`)

all_equal(result, test)
# [1] TRUE
