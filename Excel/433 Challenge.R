library(tidyverse)
library(readxl)

input = read_excel("Excel/433 Text Split.xlsx", range = "A1:B20")
test  = read_excel("Excel/433 Text Split.xlsx", range = "C1:G20")

result = input %>%
  separate(Text, into = c("Levels", "Names"), sep = " : ") %>%
  separate(Levels, into = c("Level1", "Level2", "Level3"), sep = "\\.") %>%
  separate(Names, into = c("First Name", "Last Name"), sep = " ") %>%
  select(-c(...2))

identical(result, test)
# [1] TRUE
