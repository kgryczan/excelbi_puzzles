library(tidyverse)
library(readxl)

path <- "300-399/315/315 Letters Removal.xlsx"
input <- read_excel(path, range = "A1:B10")
test <- read_excel(path, range = "C1:C10")

planet_letters <- input$Planets |>
  na.omit() |>
  tolower() |>
  paste(collapse = "") |>
  str_split("") |>
  unlist() |>
  unique() |>
  paste(collapse = "")

result <- input |>
  mutate(
    `Answer Expected` = Author |>
      str_remove_all(regex(
        paste0("[", planet_letters, "]"),
        ignore_case = TRUE
      )) |>
      str_squish() |>
      na_if("")
  ) |>
  select(`Answer Expected`)

all.equal(result, test)
# [1] TRUE
