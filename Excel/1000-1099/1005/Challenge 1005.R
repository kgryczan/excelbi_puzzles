library(tidyverse)
library(readxl)

path <- "1000-1099/1005/1005 - Overlapping Words.xlsx"
input <- read_excel(path, range = "A2:B22")
test <- read_excel(path, range = "D2:E5")

result <- input %>%
  summarise(
    Word = paste0(
      first(Fragment),
      paste0(str_sub(Fragment[-1], -1), collapse = "")
    ),
    .by = Group
  )

# different words in answers.
