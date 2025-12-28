library(tidyverse)
library(readxl)

path <- "Power Query/300-399/352/PQ_Challenge_352.xlsx"
input <- read_excel(path, range = "A1:E49")
test <- read_excel(path, range = "G1:N21")

result = input %>%
  fill(Date, User, .direction = "down") %>%
  rename(Old = `Old Value`, New = `New Value`) %>%
  pivot_wider(
    names_from = Field,
    values_from = c(Old, New),
    names_glue = "{.value} {Field}",
    names_vary = "slowest"
  )

all.equal(result, test)
# [1] TRUE
