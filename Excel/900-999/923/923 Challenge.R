library(tidyverse)
library(readxl)

path <- "Excel/900-999/923/923 Parts and Dimensions.xlsx"
input <- read_excel(path, range = "A2:A20")
test <- read_excel(path, range = "C2:D20")

pattern_dims = "\\b\\d+(?:\\.\\d+)?(?:\\s*[xX*]\\s*\\d+(?:\\.\\d+)?)+\\b"
pattern_part = "P[A-Z0-9]{5}"

result = input %>%
  mutate(
    `Part No.` = map_chr(
      str_extract_all(Data, pattern_part),
      ~ paste(.x, collapse = ", ")
    ),
    dimensions = str_extract_all(Data, pattern_dims)
  ) %>%
  unnest(dimensions) %>%
  mutate(
    dims = map(dimensions, ~ str_split(.x, "\\s*[xX*]\\s*")[[1]]) %>%
      map(as.numeric) %>%
      map_dbl(sum)
  ) %>%
  summarise(
    `Sum of Dimensions` = sum(dims, na.rm = TRUE) %>% as.character(),
    .by = `Part No.`
  )

all.equal(result, test, check.attributes = FALSE)
# one result incorrect.
