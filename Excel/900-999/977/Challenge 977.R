library(tidyverse)
library(readxl)

path <- "900-999/977/977 Balanced Brackets.xlsx"
input <- read_excel(path, range = "A2:A22")
test <- read_excel(path, range = "B2:C22")

solve <- function(s) {
  x <- strsplit(s, "")[[1]]
  if (length(x) %% 2 || sum(x == "(") != sum(x == ")")) {
    return(list(swaps = -1, result = "Impossible"))
  }
  bal <- cumsum(ifelse(x == "(", 1, -1))
  swaps <- ceiling(abs(min(0, bal)) / 2)
  if (!swaps) {
    return(list(swaps = 0, result = s))
  }
  for (. in seq_len(swaps)) {
    i <- which(x == ")")[1]
    j <- tail(which(x == "("), 1)
    x[c(i, j)] <- x[c(j, i)]
  }
  list(swaps = swaps, result = paste0(x, collapse = ""))
}

result <- input %>%
  mutate(
    output = map_chr(Parentheses, ~ solve(.x)$result),
    swaps = map_int(Parentheses, ~ solve(.x)$swaps)
  )

all.equal(result$output, test$`Example Balanced Result`)
# Solution almost correct.
