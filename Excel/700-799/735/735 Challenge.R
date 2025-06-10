library(tidyverse)
library(readxl)

path = "Excel/700-799/735/735 Transpose.xlsx"
input = read_excel(path, range = "A2:A6")
test = read_excel(path, range = "C2:D7")

result = input %>%
  separate_longer_delim(String, delim = ", ") %>%
  separate_wider_delim(
    String,
    delim = " - ",
    names = c("Planets", "Alphabet")
  ) %>%
  summarise(
    Planets = paste0(unique(Planets), collapse = ", "),
    .by = Alphabet
  ) %>%
  arrange(Alphabet)

all.equal(result, test, check.attributes = FALSE)
# Earth missed in expected result
