library(tidyverse)
library(readxl)

path = "Excel/077 Elo Ratings.xlsx"
input = read_excel(path, sheet = "Sheet2", range = "A1:C21")
test  = read_excel(path, sheet = "Sheet2", range = "E2:G5")

result = input %>%
  mutate(diff = `Nov-21 Rank` - `Nov-22 Rank`) 

best = result %>% 
  slice_max(diff, n = 1) %>%
  mutate(Category = "Best")
worst = result %>% 
  slice_min(diff, n = 1) %>%
  mutate(Category = "Worst")

result = bind_rows(best, worst) %>%
  select(Category, Team, `Improved by` = diff)

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE