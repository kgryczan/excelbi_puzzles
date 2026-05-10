library(tidyverse)
library(readxl)

path <- "300-399/390/PQ_Challenge_390.xlsx"
input <- read_excel(path, range = "A1:A9")
test <- read_excel(path, range = "C1:E13")

pattern = "^\\s*(?=[^,]*-\\s*([^,]+?)\\s*$)([^(,-]+?)\\s*(\\([^)]+\\))?\\s*-\\s*[^,]+?\\s*$"
result = input %>%
  separate_longer_delim(Data, delim = ", ") %>%
  extract(
    Data,
    into = c("State", "City", "Capitality"),
    regex = pattern,
    remove = TRUE
  ) %>%
  mutate(
    Capitality = if_else(Capitality == "(C)", "Capital", "Other Cities")
  ) %>%
  pivot_wider(
    names_from = Capitality,
    values_from = City,
    values_fn = list(City = ~ paste(., collapse = ", "))
  ) %>%
  arrange(State)

all.equal(result, test)
# One dicrepancy. New Mexico without space in test data.
