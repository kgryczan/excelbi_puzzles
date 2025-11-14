library(tidyverse)
library(readxl)

path = "Excel/800-899/848/848 Alignment.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:AF10") %>%
  mutate(across(everything(), ~ str_replace_all(replace_na(., ""), "\\.", "")))

align_matrix <- function(words) {
  chars <- str_split(words, "")
  accumulate(
    chars,
    \(a, c) {
      x <- intersect(c, a)
      if (!length(x)) return(c)
      s <- which(a == x[1])[1] - which(c == x[1])[1]
      if (s < 0) return(c)
      c(rep("", s), c)
    }
  ) |>
    {\(al) {
      m <- max(lengths(al))
      do.call(rbind, map(al, \(x) c(x, rep("", m - length(x)))))
    }}()
}

all.equal(
  align_matrix(input[[1]]) %>% as_tibble(),
  test,
  check.attributes = FALSE,
  check.names = FALSE
)

