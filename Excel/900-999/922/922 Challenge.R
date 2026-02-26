library(tidyverse)
library(readxl)

path <- "Excel/900-999/922/922 Reduce to Single Letter.xlsx"
input <- read_excel(path, range = "A1:A11")
test <- read_excel(path, range = "B1:B11")

result = input %>%
  mutate(Data = str_replace_all(Data, "([A-Za-z])\\1+", "\\1"))

all.equal(result$Data, test$`Answer Expected`, check.attributes = FALSE)
# one test case is wrong.
