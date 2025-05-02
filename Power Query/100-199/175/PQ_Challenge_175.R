library(tidyverse)
library(readxl)

input = read_excel("Power Query/PQ_Challenge_175.xlsx", range = "A1:C16")
test  = read_excel("Power Query/PQ_Challenge_175.xlsx", range = "E1:H19") %>%
  mutate(Relantionship = str_remove_all(Relantionship, " ")) # cleaned for purpose of validation

result = input %>%
  left_join(input, by = c("Family" = "Family")) %>%
  filter(`Generation No.x` == `Generation No.y` - 1) %>%
  # there is mispronunciation in the challenge, it should be "Relationship" not "Relantionship"
  unite("Relantionship", `Generation No.x`, `Generation No.y`, sep = "-") %>% 
  select(Name = `Name.x`,Family,`Next Generation` = `Name.y`, Relantionship  ) %>%
  arrange(Family, Relantionship  , Name, `Next Generation`)

identical(result, test)
# [1] TRUE

