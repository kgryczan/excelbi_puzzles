library(tidyverse)
library(readxl)

p <- "1000-1099/1034/1034 Directional Pattern Replacement.xlsx"
data <- read_excel(p, range = "A1:E17")

replace_pattern <- function(source, direction, pattern, replacement) {
  chars <- str_split_1(source, "")
  tokens <- str_split_1(pattern, "")
  step <- if (direction == "F") 1L else -1L
  cursor <- if (direction == "F") 0L else length(chars) + 1L

  positions <- map_int(tokens, \(token) {
    if (is.na(cursor)) {
      return(NA_integer_)
    }
    candidates <- if (step == 1L && cursor < length(chars)) {
      seq.int(cursor + 1L, length(chars))
    } else if (step == -1L && cursor > 1L) {
      seq.int(cursor - 1L, 1L, by = -1L)
    } else {
      integer()
    }
    hit <- candidates[which(token == "*" | chars[candidates] == token)[1]]
    cursor <<- hit
    hit
  })

  if (anyNA(positions)) {
    return(source)
  }

  chars[positions] <- str_split_1(as.character(replacement), "")
  str_c(chars, collapse = "")
}

data <- data %>%
  mutate(
    Result = pmap_chr(
      list(Source, Direction, Pattern, Replacement),
      replace_pattern
    )
  )

all.equal(data$Result, data$`Answer Expected`)
