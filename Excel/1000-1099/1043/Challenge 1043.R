library(tidyverse)
library(readxl)

path <- "1000-1099/1043/1043 Extraction.xlsx"
input <- read_excel(path, range = "A2:A12")
test <- read_excel(path, range = "C2:F12")

result <- input %>%
  mutate(rn = row_number()) %>%
  separate_longer_delim(Data, delim = " ") %>%
  mutate(
    valid = str_detect(Data, "^\\(.*\\)$|^\\[.*\\]$|^\\{.*\\}$"),
    Data = str_remove_all(Data, "[\\[{()}\\]]")
  ) %>%
  separate_wider_delim(Data, delim = ":", names = c("name", "value")) %>%
  mutate(value = if_else(valid, value, NA_character_)) %>%
  select(-valid) %>%
  pivot_wider(
    names_from = name,
    values_from = value,
    values_fn = \(x) {
      if (all(is.na(x))) {
        NA_character_
      } else {
        str_flatten(x, collapse = ", ", na.rm = TRUE)
      }
    }
  ) %>%
  select(-rn) %>%
  select(sort(names(.)))

all.equal(result, test)
#True
