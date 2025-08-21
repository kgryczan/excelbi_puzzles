library(tidyverse)
library(readxl)

input = read_excel("Excel/700-799/787/787 Right Answer Selection.xlsx", range = "A2:C14")
test  = read_excel("Excel/700-799/787/787 Right Answer Selection.xlsx", range = "E2:H5")

r1 = input %>% filter(str_detect(No, "^[0-9]+$") | Correct == "Y") %>% select(-Correct)

result = bind_cols(
  filter(r1, str_detect(No, "^[0-9]+$")),
  filter(r1, !str_detect(No, "^[0-9]+$"))
) %>% set_names(colnames(test)) %>% mutate(No = as.integer(No))

all.equal(result, test)
