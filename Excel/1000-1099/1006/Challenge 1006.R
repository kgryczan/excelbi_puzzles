library(tidyverse)
library(readxl)

path <- "1000-1099/1006/1006 Max Number Following a Pattern.xlsx"
input <- read_excel(path, range = "A1:C12")
test <- read_excel(path, range = "D1:D12")

max_by_rule <- function(rule, from, to) {
  p <- unlist(strsplit(rule, "/", fixed = TRUE))

  rx <- p[1] %>%
    str_replace_all(c(
      E = "[02468]",
      O = "[13579]",
      X = "[0-9]"
    ))

  rx <- str_c(
    "^",
    if (length(p) > 1) str_c("(?!.*[", p[2], "])") else "",
    rx,
    "$"
  )

  str_c(to:from) %>%
    keep(~ str_detect(.x, regex(rx))) %>%
    first() %>%
    as.integer()
}

result <- input %>%
  mutate(
    result = pmap_int(
      across(c(Rule, Start, End)),
      ~ max_by_rule(..1, ..2, ..3)
    )
  ) %>%
  mutate(result = as.character(result)) %>%
  mutate(result = replace_na(result, "None"))

all.equal(result$result, test$`Answer Expected`)
# TRUE
