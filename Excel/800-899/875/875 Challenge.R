library(tidyverse)
library(readxl)

path <- "Excel/800-899/875/Excel_Challenge_875 - Counting As Per Criteria.xlsx"
input <- read_excel(path, range = "A1:A25")
test <- read_excel(path, range = "B1:B25")

result = input %>%
  mutate(chars = str_split(Data, "")) %>%
  unnest(chars) %>%
  mutate(count = cumsum(chars == " ") + 1, .by = Data) %>%
  filter(chars != " ") %>%
  mutate(var = ifelse(chars > lag(chars, default = NA), 1L, 0L), .by = Data) %>%
  mutate(
    var = ifelse(row_number() == 1, NA_integer_, var),
    .by = c(Data, count)
  ) %>%
  summarise(Result = sum(var, na.rm = TRUE), .by = c(Data, count)) %>%
  filter(Result != 0) %>%
  summarise(
    `Answer Expected` = as.numeric(paste0(Result, collapse = "")),
    .by = Data
  )

r1 = input %>%
  left_join(result, by = "Data")

all.equal(
  r1$`Answer Expected`,
  test$`Answer Expected`,
  check.attributes = FALSE
)
#> [1] TRUE
