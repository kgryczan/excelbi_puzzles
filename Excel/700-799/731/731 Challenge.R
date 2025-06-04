library(tidyverse)
library(readxl)

path = "Excel/700-799/731/731 Generate Fill Sequence Blanks.xlsx"
input = read_excel(path, range = "A2", col_names = FALSE) %>% pull()
test = read_excel(path, range = "A3:A37", col_names = "Answer Expected")

result = map(
  1:input,
  ~ tibble(Answer = LETTERS[.x], `Answer Expected` = rep(NA_character_, .x + 1))
) %>%
  bind_rows() %>%
  mutate(
    `Answer Expected` = ifelse(row_number() == 1, Answer, `Answer Expected`),
    .by = Answer
  )

all.equal(
  result$`Answer Expected`,
  test$`Answer Expected`,
  check.attributes = FALSE
)
# [1] TRUE
