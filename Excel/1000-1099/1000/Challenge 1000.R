library(tidyverse)
library(readxl)

path <- "1000-1099/1000/1000 Count 2 Words Only Names.xlsx"
input <- read_excel(path, range = "A1:A20")
test <- read_excel(path, range = "B1:B2")

result <- input %>%
  summarise(
    `Answer Expected` = sum(str_count(.[[1]], "\\w+") == 2, na.rm = TRUE)
  )

all.equal(result, test)
# > [1] TRUE
