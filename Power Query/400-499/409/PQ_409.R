library(tidyverse)
library(readxl)

path <- "400-499/409/PQ_Challenge_409.xlsx"
input <- read_excel(path, range = "A1:C21")
test <- read_excel(path, range = "E1:H82")

solve <- function(ID, Data1, Data2) {
  a <- str_split(Data1, ",")[[1]]
  b <- str_split(Data2, ",")[[1]]
  pairs <- map2(
    a,
    b,
    ~ case_when(
      .x == "" & .y == "" ~ list(c(NA_character_, NA_character_)),
      .x == "" ~ list(c(.y, .y)),
      .y == "" ~ list(c(.x, .x)),
      TRUE ~ list(c(.x, .y))
    )[[1]]
  )
  pairs <- accumulate(
    pairs,
    ~ if (all(is.na(.y))) .x else .y,
    .init = c("N/A", "N/A")
  )[-1]
  tibble(
    ID = ID,
    Step = seq_along(pairs),
    Out1 = map_chr(pairs, 1),
    Out2 = map_chr(pairs, 2)
  )
}
result <- pmap_dfr(input, solve)
all.equal(result, test)
# TRUE
