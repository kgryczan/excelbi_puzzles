library(tidyverse)
library(readxl)

path <- "1000-1099/1007/1007 String Processing.xlsx"
input <- read_excel(path, range = "A1:C10")
test <- read_excel(path, range = "D1:D10")

solve_one <- function(Text, Pattern, Dropset) {
  x <- str_split(Text, "")[[1]]
  p <- str_extract_all(Pattern, "\\d+")[[1]] |> as.integer()
  d <- str_split(coalesce(Dropset, ""), "")[[1]]
  lens <- rep(p, length.out = length(x))
  lens <- lens[cumsum(lens) - lens < length(x)]
  chunks <- split(x, rep(seq_along(lens), lens)[seq_along(x)])
  was_rotated <- map_lgl(chunks, \(z) length(z) %% 2 == 0)
  chunks <- map2(chunks, was_rotated, \(z, r) {
    if (r) rev(z) else z
  })
  chunks <- map(chunks, \(z) z[!z %in% d])
  chunks <- map2(chunks, was_rotated, \(z, r) {
    if (!r && length(z) %% 2 == 0) rev(z) else z
  })
  chunks |>
    rev() |>
    map_chr(str_c, collapse = "") |>
    str_c(collapse = "")
}

result <- input %>%
  mutate(
    `Answer Expected` = pmap_chr(
      list(Text, Pattern, Dropset),
      solve_one
    )
  )

all.equal(result$`Answer Expected`, test$`Answer Expected`)
# [1] TRUE
