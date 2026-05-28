library(tidyverse)
library(readxl)

path <- "900-999/987/987 Extraction.xlsx"
input <- read_excel(path, range = "A1:A10")
test <- read_excel(path, range = "B1:B10")

result = input %>%
  mutate(
    Code = str_match(
      Data,
      "(?::|/|=|-)\\s*([A-Z]\\d+(?:-\\d+)?|[A-Z][A-Za-z]+\\d+(?:-\\d+)?)(?=[/#$]|$)"
    )[, 2],
    Qty = str_match(Data, "(?:Q|#)(\\d+)(?=\\$|[^0-9])")[, 2],
    Value = str_match(Data, "(?:\\$V?|\\bV)(\\d+(?:\\.\\d+)?)")[, 2],
    Status = str_match(Data, "@?(ACT|PEND|CMP)")[, 2],
    Priority = str_match(Data, "#P(\\d)")[, 2],
    Output = str_c(Code, Qty, Value, str_c(Status, Priority), sep = "-")
  )
all.equal(result$Output, test$AnswerExpected)
# [1] TRUE
