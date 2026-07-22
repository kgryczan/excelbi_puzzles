library(tidyverse)
library(readxl)

path <- "1000-1099/1026/1026 Grouped Mail IDs.xlsx"
input <- read_excel(path, range = "A2:C20")
test <- read_excel(path, range = "E2:F8") # drop rows absent in source

result <- input %>%
  mutate(Email = str_to_lower(Email)) %>%
  filter(
    !str_ends(Email, "@gmail.com") |
      !str_detect(str_extract(Email, "^[^@]+"), fixed("+"))
  ) %>%
  distinct() %>%
  summarise(
    `Canonical Email` = paste0(unique(Email), collapse = ", "),
    .by = Customer
  )

all.equal(result, test)
# True
