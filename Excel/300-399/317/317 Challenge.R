library(tidyverse)
library(readxl)

path <- "300-399/317/317 Swap First and Last Letter in Words.xlsx"
input <- read_excel(path, range = "A1:A10")
test <- read_excel(path, range = "B1:B10")

vowels <- "[aeiouAEIOU]"

swap_word <- function(w) {
  if (str_detect(w, "\\.$") || nchar(w) <= 1) {
    return(w)
  }
  if (
    str_detect(str_sub(w, 1, 1), vowels) || str_detect(str_sub(w, -1), vowels)
  ) {
    return(w)
  }
  paste0(str_sub(w, -1), str_sub(w, 2, -2), str_sub(w, 1, 1))
}

result <- input |>
  mutate(
    `Answer Expected` = str_split(Names, " ") |>
      map_chr(~ map_chr(.x, swap_word) |> paste(collapse = " ")) |>
      str_to_title()
  )

all.equal(result$`Answer Expected`, test$`Answer Expected`)
# [1] TRUE
