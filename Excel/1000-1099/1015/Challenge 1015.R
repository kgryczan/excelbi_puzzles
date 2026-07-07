library(tidyverse)
library(readxl)

path <- "1000-1099/1015/1015 Logic Gates.xlsx"
input <- read_excel(path, range = "A1:D21")
test <- read_excel(path, range = "E1:E21")

f <- list(
  AND = `&`,
  OR = `|`,
  XOR = xor,
  NOT = \(x, y) !x,
  NAND = \(x, y) !(x & y),
  NOR = \(x, y) !(x | y),
  XNOR = \(x, y) !xor(x, y)
)
values <- list()

get_value <- \(x) {
  if (is.na(x)) {
    NA
  } else if (x %in% c("0", "1")) {
    as.logical(as.integer(x))
  } else {
    values[[x]]
  }
}

calculate_row <- \(Gate, Type, Input1, Input2) {
  x <- get_value(Input1)
  y <- get_value(Input2)

  result <- f[[Type]](x, y)
  values[[Gate]] <<- result

  as.integer(result)
}

result <- input %>%
  mutate(
    Result = pmap_int(
      list(Gate, Type, Input1, Input2),
      calculate_row
    )
  )

all.equal(result$Result, test$`Answer Expected`, check.attributes = FALSE)
# True
