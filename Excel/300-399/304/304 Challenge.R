library(tidyverse)
library(readxl)
library(data.table)

path = "Excel/300-399/304/304 Winning Team.xlsx"
input = read_excel(path, range = "A1:B10")
test = read_excel(path, range = "C1:C4")

extract_values <- function(string) {
  values <- str_extract_all(string, "\\d+")[[1]]
  tibble(
    wins = as.integer(values[1]),
    draws = as.integer(values[2]),
    loses = as.integer(values[3])
  )
}

result = input %>%
  mutate(
    wins = map(Stat, extract_values) %>% map_dbl("wins"),
    draws = map(Stat, extract_values) %>% map_dbl("draws"),
    loses = map(Stat, extract_values) %>% map_dbl("loses"),
    points = wins * 1 + draws * 0 + loses * -1
  ) %>%
  arrange(desc(points)) %>%
  head(3) %>%
  select(Teams)