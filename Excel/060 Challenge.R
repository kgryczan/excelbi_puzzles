library(tidyverse)
library(readxl)
library(rlang)

path = "Excel/060 MathOps.xlsx"
input1 = read_excel(path, range = "A1:A20")
input2 = read_excel(path, range = "C1:F5")
test  = read_excel(path, range = "H1:H5")

r1 = input1 %>%
  mutate(nr = row_number() %>% as.character()) 


r2 = input2 %>%
  mutate(across(1:2, ~ as.numeric(parse_number(.x)) - 1)) %>%
  unite("cond" , 3:4, sep = " ") %>%
  rowwise() %>%
  mutate(seq = seq(from = `Start Range`, to = `End Range`, by = 1) %>% paste0(collapse = ",")) %>%
  ungroup() %>%
  select(-`Start Range`, -`End Range`) %>%
  separate_rows(seq, sep = ",")  %>%
  left_join(r1, by = c("seq" = "nr")) %>%
  mutate(expr = paste0(Data, " ", cond), 
         expr = str_replace(expr, " = ", " == "),
         expr = str_replace(expr, "<>", "!=")) %>%
  mutate(result = map_dbl(expr, ~ eval(parse(text = .x)))) %>%
  summarise(Data = sum(Data[result == 1]), .by = cond) %>%
  select(Data)

identical(test$`Answer Expected`, r2$Data)
# [1] TRUE  
