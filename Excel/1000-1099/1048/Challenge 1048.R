library(tidyverse)
library(readxl)

path <- "1000-1099/1048/1048 Replace X With Sum of Digits.xlsx"
input <- read_excel(path, range = "A1:A11")
test <- read_excel(path, range = "B1:B11")

replace_x <- function(x) {
  reduce(
    seq_len(str_count(x, "X")),
    \(s, ...) {
      i <- str_locate(s, "X")[1]
      l <- str_extract(str_sub(s, 1, i - 1), "\\d$")
      r <- str_extract(str_sub(s, i + 1), "\\d")

      str_replace(s, "X", as.character(as.numeric(l) + as.numeric(r)))
    },
    .init = x
  )
}

result <- input %>%
  transmute(`Answer Expected` = map_chr(Data, replace_x))

all.equal(result, test)
# True
