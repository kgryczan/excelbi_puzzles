library(tidyverse)
library(readxl)

path <- "Excel/800-899/893/893 Capitalize at Same Indexes.xlsx"
input <- read_excel(path, range = "A1:A10")
test <- read_excel(path, range = "B1:B10")

myfun <- function(text) {
  tibble(ch = str_split(text, "")[[1]]) |>
    mutate(
      i1 = row_number(),
      i2 = cumsum(ch != " "),
      cap = str_detect(ch, "[A-Z]")
    ) |>
    (\(df) {
      cap1 <- df$i1[df$cap]
      df |>
        mutate(
          ch = str_to_lower(ch),
          ch = if_else(i2 %in% cap1 & ch != " ", str_to_upper(ch), ch)
        )
    })() |>
    summarise(out = str_c(ch, collapse = "")) |>
    pull(out)
}

result = input %>%
  rowwise() %>%
  mutate(result = myfun(Sentences))

all.equal(result$result, test$`Answer Expected`)
# TRUE
