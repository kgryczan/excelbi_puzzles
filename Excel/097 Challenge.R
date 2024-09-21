library(tidyverse)
library(readxl)

path = "Excel/097 Unique Digit Numbers.xlsx"
input = read_excel(path, range = "A1:B5")
test  = read_excel(path, range = "C1:C5")

result = input %>%
  rowwise() %>%
  mutate(Sequence = list(seq(From, To))) %>%
  unnest(Sequence) %>%
  filter(Sequence %% 2 == 1) %>%
  mutate(Sequence = as.character(Sequence),
         nchar = nchar(Sequence),
         unique_digits = str_split(Sequence, "") %>% map(unique) %>% map_int(length)) %>%
  filter(nchar == unique_digits) %>%
  summarise(Count = n(), .by = c(From, To))

all.equal(result$Count, test$Count, check.attributes = FALSE)
# [1] TRUE