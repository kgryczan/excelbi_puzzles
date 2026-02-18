library(tidyverse)
library(readxl)

path <- "Excel/900-999/915/915 Missing Invoice Numbers.xlsx"
input <- read_excel(path, range = "A1:A24")
test <- read_excel(path, range = "B1:B13") %>%
  arrange(`Answer Expected`)

result = input %>%
  separate(
    Invoice_ID,
    into = c("prefix", "number"),
    sep = "-",
    remove = FALSE,
    convert = TRUE
  ) %>%
  group_by(prefix) %>%
  complete(number = full_seq(number, 1)) %>%
  ungroup() %>%
  filter(is.na(Invoice_ID)) %>%
  unite("Invoice_ID", prefix, number, sep = "-")

all.equal(result$Invoice_ID, test$`Answer Expected`)
# [1] TRUE
