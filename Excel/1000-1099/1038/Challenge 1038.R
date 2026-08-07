library(tidyverse)
library(readxl)

path <- "C:/Users/kgryc/Documents/excelbi_puzzles/Excel/1000-1099/1038/1038 Data Extraction.xlsx"
input <- read_excel(path, range = "A2:A22")
test <- read_excel(path, range = "B2:C22")

fields <- map(
  input$Data,
  ~ str_split(.x, ',(?=(?:[^"]*"[^"]*")*[^"]*$)')[[1]] %>%
    str_replace_all('""', '"') %>%
    str_replace_all('^"|"$', '') %>%
    str_trim()
)
salary <- map_chr(fields, last)
match <- str_match(salary, "^\\+?((?:\\d+(?:\\.\\d+)?|\\.\\d+))([KMBkmb]?)$")
multiplier <- case_when(
  str_to_upper(match[, 3]) == "K" ~ 1e3,
  str_to_upper(match[, 3]) == "M" ~ 1e6,
  str_to_upper(match[, 3]) == "B" ~ 1e9,
  TRUE ~ 1
)
amount <- as.numeric(match[, 2]) * multiplier
result <- tibble(
  Employee = map_chr(fields, 2) %>% str_replace_all('^"|"$', '') %>% na_if(""),
  Salary = if_else(
    !is.na(match[, 1]) & amount > 0,
    floor(amount + .5),
    NA_real_
  )
)
all.equal(result, test)
