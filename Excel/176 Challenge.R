library(tidyverse)
library(readxl)

path = "Excel/176 Team Members.xlsx"
input = read_excel(path, range = "A1:A8")
test  = read_excel(path, range = "B1:B8")

split_names = function(x) {
  x = gsub(" ", "", x)
  x = strsplit(x, ",")[[1]]
  n = length(x)
  res = case_when(
    n == 1 & is.na(x[1]) ~ "No one is in team",
    n == 1 ~ paste0(x[1], " is in team"),
    n == 2 ~ paste0(x[1], " and ", x[2], " are in team"),
    n > 2 ~ paste0(x[1], " and ", n - 1, " others are in team"),
    TRUE ~ "No one is in team"
  )
  return(res)
}

result = input %>%
  mutate(`Answer Expected` = map_chr(Names, split_names)) %>%
  select(`Answer Expected`)

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE