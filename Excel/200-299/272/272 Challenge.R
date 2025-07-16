library(tidyverse)
library(readxl)

path = "Excel/200-299/272/272 Teams Max Goals.xlsx"
input = read_excel(path, range = "A1:D11")
test  = read_excel(path, range = "F2:G6") %>%
  mutate(`Total Goals` = as.integer(`Total Goals`))

result = input %>%
  separate(Result, into = c("home", "away"), sep = "-", convert = TRUE) %>%
  mutate(total = home + away) %>%
  mutate(rank = dense_rank(desc(total))) %>%
  filter(rank <= 3) %>%
  arrange(rank, Match) %>%
  select(Match, `Total Goals` = total)

all.equal(result, test)
# > [1] TRUE