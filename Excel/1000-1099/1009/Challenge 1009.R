library(tidyverse)
library(readxl)
library(plu)
library(english)

path <- "1000-1099/1009/1009 Plurals.xlsx"
input <- read_excel(path, range = "A1:B10")
test <- read_excel(path, range = "C1:C10")

result <- input %>%
  mutate(
    `Answer Expected` = paste0(words(Count), " ", ral(Word, n = Count))
  ) %>%
  select(`Answer Expected`)

all.equal(result, test, check.attributes = FALSE)
# Fairies wrong in original.
