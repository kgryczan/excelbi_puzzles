library(tidyverse)
library(readxl)

path = "Excel/700-799/774/774 Names Having Common Words.xlsx"
input = read_excel(path, range = "A2:A22")
test  = read_excel(path, range = "C2:D18") %>% arrange(Words, Names)

common_words = input %>%
  mutate(id = row_number()) %>%
  separate_rows(Names, sep = " ") %>%
  count(Names, sort = TRUE) %>%
  filter(n > 1) %>%
  pull(Names)

result = expand.grid(common_words, input$Names, stringsAsFactors = F) %>%
  filter(str_detect(Var2, Var1)) %>%
  arrange(Var1, Var2)

all.equal(result, test, check.names = FALSE, check.attributes = FALSE)
#<> [1] TRUE