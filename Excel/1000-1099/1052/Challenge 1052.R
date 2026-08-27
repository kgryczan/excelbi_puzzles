library(tidyverse)
library(readxl)

path <- "1000-1099/1052/1052 Country Codes to Column Numbers.xlsx"
input <- read_excel(path, range = "A1:B21")
test <- read_excel(path, range = "C1:C21")

excel_number <- \(code) sum(match(strsplit(code, "")[[1]], LETTERS) * 26^(2:0))

excel_header <- \(n) {
  if (n == 0) {
    ""
  } else {
    paste0(
      excel_header((n - 1) %/% 26),
      LETTERS[(n - 1) %% 26 + 1]
    )
  }
}

result <- input %>%
  mutate(
    n1 = map_int(`Code 1`, excel_number),
    n2 = map_int(`Code 2`, excel_number),
    Midpoint = floor((n1 + n2) / 2),
    Result = map_chr(Midpoint, excel_header)
  ) %>%
  select(Result)

all.equal(result$Result, test$`Answer Expected`)
# True
