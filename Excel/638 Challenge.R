library(tidyverse)
library(readxl)

path = "Excel/638 Days of the Week Abbreviation.xlsx"
input = read_excel(path, range = "A2:C9")
test  = read_excel(path, range = "D2:F9")

abbreviate = function(column) {
  for (i in seq_len(nchar(column[1]))) {
    abbrs = substr(column, 1, i)
    if (length(unique(abbrs)) == length(column)) {
      return(abbrs)
    }
  }
}

result = input %>%
  mutate(across(everything(), ~ abbreviate(.)))

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE