library(tidyverse)
library(readxl)

path <- "1000-1099/1045/1045 Repeating Sequence.xlsx"
input <- read_excel(path, range = "A2:C36")
test <- read_excel(path, range = "E2:F7")

repeats <- function(x) {
  hits <- map_dfr(seq_along(x), \(i) {
    m <- str_match(str_c(x[i:length(x)], collapse = ""), "^(.+?)\\1+")[1]
    if (is.na(m)) tibble() else tibble(len = nchar(m), pos = i)
  })
  if (!nrow(hits)) {
    return("")
  }
  hits <- arrange(hits, desc(len), desc(pos))
  chosen <- reduce(
    seq_len(nrow(hits)),
    \(out, i) {
      z <- hits[i, ]
      if (
        !any(map_lgl(out, \(y) z$pos < y$pos + y$len && y$pos < z$pos + z$len))
      ) {
        append(out, list(z))
      } else {
        out
      }
    },
    .init = list()
  )
  str_c(
    pmap_chr(arrange(bind_rows(chosen), pos), \(len, pos) {
      str_c(x[pos:(pos + len - 1)], collapse = "-")
    }),
    collapse = ", "
  )
}

result <- input %>%
  group_by(CustomerID) %>%
  summarise(RepeatingSequence = repeats(Product), .groups = "drop")
all.equal(
  result,
  test %>% mutate(RepeatingSequence = replace_na(RepeatingSequence, ""))
)
