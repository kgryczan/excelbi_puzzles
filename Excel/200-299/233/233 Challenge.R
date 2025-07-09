library(tidyverse)
library(readxl)

path = "Excel/200-299/233/233 Valid Names.xlsx"
input = read_excel(path, range = "A1:A11")
test  = read_excel(path, range = "B1:B6")

result = input %>%
  mutate(Name = str_split(Names, " ")) %>%
  unnest(Name) %>%
  mutate(word_len = str_length(Name)) %>%
  filter(sum(word_len) != n(), .by = Names) %>%
  mutate(dupes = duplicated(Name) | duplicated(Name, fromLast = TRUE)) %>%
  filter(max(dupes, na.rm = TRUE) == FALSE, n() > 1, .by = Names) %>%
  select(Names) %>%
  distinct() 

all.equal(result$Names, test$`Expected Answer`, check.attributes = FALSE)
# > [1] TRUE