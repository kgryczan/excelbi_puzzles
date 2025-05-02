library(tidyverse)
library(readxl)

path = "Excel/672 Find Level Entries.xlsx"
input = read_excel(path, range = "A3:B10", col_names = c("Level1", "Level2"))
test  = read_excel(path, range = "D3:E10", col_names = c("Level1", "Level2"))

result = input %>%
  mutate(rn = row_number(), Level = Level1) %>% 
  fill(Level1) %>%
  arrange(Level1, Level2) %>%
  mutate(across(everything(), as.numeric),
         Level2 = ifelse(is.na(Level2), Level1 - lag(Level2), Level2)) %>%
  arrange(rn) %>%
  select(Level1 = Level, Level2)

all.equal(result, test, check.attributes = FALSE) # True
