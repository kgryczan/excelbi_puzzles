library(tidyverse)
library(readxl)

path = "Power Query/200-299/297/PQ_Challenge_297.xlsx"
input = read_excel(path, range = "A1:B6")
test  = read_excel(path, range = "D1:F15")

result = input %>%
  separate_longer_delim(`Animals & Count`, delim = ", ") %>%
  separate_wider_delim(`Animals & Count`, delim = "-", names = c("Animal", "Count"), too_few = "align_start", ) %>%
  mutate(Count = coalesce(as.numeric(Count),1)) %>%
  arrange(parse_number(Cage), Animal) %>%
  mutate(Cage = if (n() == 1) Cage else paste0(Cage, "_", row_number()), .by = Cage) 

all.equal(result, test, check.attributes = FALSE)
