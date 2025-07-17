library(tidyverse)
library(readxl)

path = "Excel/700-799/762/762 Alphabets Pivot.xlsx"
input = read_excel(path, range = "A2:A6")
test  = read_excel(path, range = "C2:D8")

result = input %>%
  mutate(fragment = str_extract_all(Data, "[A-Za-z]+\\d+")) %>%
  unnest_longer(fragment) %>%
  mutate(
    letters = str_extract(fragment, "[A-Za-z]+"),
    digits = as.numeric(str_extract(fragment, "\\d+")),
    Alphabet = str_split(letters, "")
  ) %>%
  unnest(Alphabet) %>%
  summarise(Value = sum(digits / str_length(letters)), .by = Alphabet) %>%
  arrange(Alphabet)

all.equal(result, test)
#># [1] TRUE