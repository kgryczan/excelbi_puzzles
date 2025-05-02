library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_244.xlsx"
input1 = read_excel(path, range = "A1:F6")
input2 = read_excel(path, range = "A9:F12")
test  = read_excel(path, range = "I1:O7")

I3 = bind_rows(input1, input2) %>%
  pivot_longer(cols = -c(Student), names_to = "Subject", values_to = "Score") %>%
  na.omit() %>%
  pivot_wider(names_from = "Subject", values_from = "Score", values_fn = list(Score = sum)) %>%
  select(Student, sort(colnames(.), decreasing = FALSE))

all.equal(I3, test)
# [1] TRUE