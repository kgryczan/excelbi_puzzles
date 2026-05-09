library(dplyr)
library(readxl)
library(slider)

path <- "300-399/389/PQ_Challenge_389.xlsx"
input <- read_excel(path, range = "A1:C29")
test <- read_excel(path, range = "E1:H25")

result <- input |>
  transmute(
    ID,
    Pattern = slide_chr(
      Code,
      paste,
      collapse = "",
      .before = 2,
      .after = 2,
      .complete = TRUE
    ),
    WindowsValueSum = slide_dbl(
      Value,
      sum,
      .before = 2,
      .after = 2,
      .complete = TRUE
    ),
    DominantCode = slide_chr(
      Code,
      \(x) {
        t <- table(x)
        names(t)[which.max(t)]
      },
      .before = 2,
      .after = 2,
      .complete = TRUE
    )
  ) |>
  na.omit()

all.equal(result, test, check.attributes = FALSE)
# TRUE
