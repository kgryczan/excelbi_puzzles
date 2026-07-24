library(tidyverse)
library(readxl)

path <- "1000-1099/1028/1028 Extract Name and Score.xlsx"
input <- read_excel(path, range = "A2:A21")
test <- read_excel(path, range = "B2:C21")

pattern <- paste0(
  "^(\\d+),",
  "(\"[^\"]*\"|'[^']*'|[^,]*),",
  "(\"[^\"]*\"|'[^']*'|[^,]*),",
  "(\"[^\"]*\"|'[^']*'|[^,]*),",
  "(\"\\d+\"|'\\d+'|\\d+)$"
)

result <- input %>%
  extract(
    `CSV Data`,
    into = c("id", "name", "department", "field", "score"),
    regex = pattern
  ) %>%
  mutate(
    across(name:score, \(x) str_remove_all(x, "^['\"]|['\"]$")),
    name = if_else(
      str_detect(name, ","),
      str_replace(name, "^(.+),\\s*(.+)$", "\\2 \\1"),
      name
    ),
    score = as.numeric(score)
  ) %>%
  select(Name = name, Score = score)

all.equal(result, test)
# True
