library(tidyverse)
library(readxl)

path = "Excel/800-899/800/800 Split and Expand.xlsx"
input = read_excel(path, range = "A2:B6")
test  = read_excel(path, range = "D2:E12")

result = input %>%
  separate_rows(Band, sep = ", ") %>%
  filter(str_detect(Band, "-")) %>%
  mutate(Band = str_split(Band, "-")) %>%
  mutate(Numbers = map(Band, ~seq(from = as.numeric(.x[1]), to = as.numeric(.x[2])))) %>%
  unnest(Numbers) %>%
  select(-Band)

all.equal(result, test, check.atrributes= T)
# TRUE
