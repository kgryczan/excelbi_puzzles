library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_279.xlsx"
input = read_excel(path, range = "A1:E8")
test = read_excel(path, range = "G1:J14")

result = input %>%
  pivot_longer(cols = Code1:Value2, names_to = c(".value", "pair_id"),
               names_pattern = "([A-Za-z]+)(\\d+)") %>%
  select(-pair_id) %>%
  na.omit() %>%
  separate(Code, into = c("Type", "Code"), sep = 2)

all.equal(result, test, check.attributes = FALSE)
