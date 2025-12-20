library(tidyverse)
library(readxl)

path <- "Power Query/300-399/349/PQ_Challenge_349.xlsx"
input <- read_excel(path, range = "A1:A70")
test <- read_excel(path, range = "C1:I70") %>%
  replace_na(list(`Middle Name` = ""))

result = input %>%
  mutate(`Precidency #` = row_number()) %>%
  mutate(
    `Full Name` = str_extract(`US Presidents`, "^[^(]+"),
    Duration = str_extract(`US Presidents`, "\\(([^)]+)\\)") %>%
      str_remove_all("\\(|\\)")
  ) %>%
  mutate(
    Name_parts = str_split(str_trim(`Full Name`), " ", simplify = FALSE)
  ) %>%
  mutate(
    `First Name` = map_chr(Name_parts, ~ .x[1]),
    `Last Name` = map_chr(Name_parts, ~ .x[length(.x)]),
    `Middle Name` = map_chr(Name_parts, function(x) {
      if (length(x) <= 2) "" else paste(x[2:(length(x) - 1)], collapse = " ")
    })
  ) %>%
  select(-Name_parts) %>%
  mutate(num_presidencies = row_number(), .by = `Full Name`) %>%
  mutate(
    `Dynasty Flag` = ifelse(n_distinct(`Full Name`) > 1, "Yes", "No"),
    .by = `Last Name`
  ) %>%
  mutate(
    `Term Check` = case_when(
      num_presidencies == 1 ~ "First Term",
      num_presidencies > 1 &
        lag(`Full Name`) == `Full Name` ~ "Re-elected (Consecutive)",
      TRUE ~ "Re-elected (Non-Consecutive)"
    )
  ) %>%
  select(
    `Precidency #`,
    `First Name`,
    `Middle Name`,
    `Last Name`,
    `Duration`,
    `Term Check`,
    `Dynasty Flag`
  )

all.equal(result, test, check.attributes = FALSE)
