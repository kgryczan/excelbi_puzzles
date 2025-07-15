library(tidyverse)
library(readxl)
library(stringi)

path = "Excel/200-299/264/264 Ananyms.xlsx"
input1 = read_excel(path, range = "A1:A9")
input2 = read_excel(path, range = "B1:B9")
test  = read_excel(path, range = "C1:C9")

i1 = input1 %>%
  mutate(rev = stri_reverse(Words1))

i2 = expand.grid(i1$rev, input2$Words2) %>%
  mutate(across(everything(), as.character)) %>%
  filter(str_detect(Var2, Var1))

result = i1 %>%
  left_join(i2, by = c("rev" = "Var1")) %>%
  select(`Answer Expected` = Var2)

all.equal(result, test, check.attributes = FALSE) 
# > [1] TRUE