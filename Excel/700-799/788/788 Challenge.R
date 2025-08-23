library(tidyverse)
library(readxl)

path = "Excel/700-799/788/788 Quiz_Table.xlsx"
input = read_excel(path, range = "A1:C30")
test  = read_excel(path, range = "E2:J9")

result = input %>%
  mutate(num = cumsum(str_detect(No, "^[0-9]+$"))) %>%
  group_by(num) %>%
  mutate(`Correct Answer` = ifelse(Correct == "Y", No, NA)) %>%
  fill(`Correct Answer`, .direction = "downup") %>% 
  select(-Correct) %>%
  ungroup() %>%
  mutate(Q = ifelse(str_detect(No, "^[0-9]+$"), Question, NA)) %>%
  fill(Q, .direction = "downup") %>%
  filter(ifelse(str_detect(No, "^[0-9]+$"), F, T)) %>%
  pivot_wider(id_cols = c(num, `Correct Answer`, Q), 
              names_from = No, 
              values_from = Question) %>%
  unite("Question", num, Q, sep = ".") %>%
  relocate(`Correct Answer`, .after = everything())

all.equal(result, test)
#$ [1] TRUE