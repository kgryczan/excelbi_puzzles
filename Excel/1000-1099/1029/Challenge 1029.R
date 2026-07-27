library(tidyverse)
library(readxl)

path <- "1000-1099/1029/1029 Running Characters Encoding Sorting.xlsx"
input <- read_excel(path, range = "A1:A22")
test <- read_excel(path, range = "A1:B22")

encode <- function(text) {
  chars <- str_split(text, "", simplify = FALSE)[[1]]
  runs <- tibble(
    char = chars,
    run = cumsum(chars != lag(chars, default = first(chars)))
  ) %>%
    count(run, char, name = "count")

  encoded <- runs %>%
    filter(count >= 3) %>%
    arrange(desc(count), run) %>%
    transmute(token = str_c(char, count)) %>%
    pull(token)

  remaining <- runs %>%
    filter(count < 3) %>%
    arrange(run) %>%
    transmute(token = str_dup(char, count)) %>%
    pull(token)

  str_c(c(encoded, remaining), collapse = "")
}

result <- input %>%
  mutate(answer = map_chr(Text, encode)) %>%
  rename("Answer Expected" = answer)

all.equal(result, test)
# TRUE
