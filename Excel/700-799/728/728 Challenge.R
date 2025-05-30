library(tidyverse)
library(readxl)

path = "Excel/700-799/728/728 Align Names.xlsx"
input = read_excel(path, range = "A2:B11")
test = read_excel(path, range = "D2:E6")

used = character(0)
results = list()

for (n1 in input$`Name 1`) {
  first = word(n1, 1)
  last = word(n1, -1)

  matches = input$`Name 2` |>
    setdiff(used) |>
    keep(~ word(.x, 1) == first || word(.x, -1) == last)

  if (length(matches) > 0) {
    used = union(used, matches)
    results[[n1]] = paste(sort(matches), collapse = ", ")
  }
}

result = tibble(
  name_1 = names(results),
  name_2 = unlist(results)
)
