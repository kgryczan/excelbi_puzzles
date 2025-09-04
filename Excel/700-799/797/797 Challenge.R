library(tidyverse)
library(readxl)

path = "Excel/700-799/797/797 Cage Alignment.xlsx"
input1 = read_excel(path, range = "A2:A6")
input2 = read_excel(path, range = "B2:B32")
test  = read_excel(path, range = "D2:E14")

i1 = input1 %>%
  separate_wider_delim(cols = 1, delim = ", ", names = c("Cage", "volume")) %>%
  uncount(as.numeric(volume)) %>%
  mutate(rn = row_number())

i2 = input2 %>%
  mutate(rn = row_number())

result = left_join(i1, i2, by = "rn") %>%
  select(-c(rn, volume)) %>%
  mutate(Cage = ifelse(row_number() == 1, Cage, NA_character_), .by = Cage)

all.equal(result, test)
# > [1] TRUE