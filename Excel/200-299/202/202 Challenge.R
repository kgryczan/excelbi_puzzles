library(tidyverse)
library(readxl)

path = "Excel/202 Highest Marks Address.xlsx"
input = read_excel(path, range = "A1:E10") 
test  = read_excel(path, range = "G1:I4")

result = input %>%
  mutate(row_index = row_number()+1, .after = everything()) %>%
  pivot_longer(cols = starts_with("Subject"), names_to = "Subjects", values_to = "Score") %>%
  mutate(rows  = LETTERS[as.numeric(str_extract(Subjects, "\\d+"))+1]) %>%
  unite("Address", c("rows", "row_index"), sep = "") %>%
  slice_max(Score, n = 1) %>%
  select(Names, Subjects, Address)

all.equal(result, test)
# [1] TRUE