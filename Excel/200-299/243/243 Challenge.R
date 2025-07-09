library(tidyverse)
library(readxl)

path = "Excel/200-299/243/243 Polybius Cipher Decrypt.xlsx"
input1 = read_excel(path, range = "A2:G8")
input2 = read_excel(path, range = "I1:I7")
test  = read_excel(path, range = "J1:J7")

i1 = input1 %>%
  pivot_longer(cols = -c(1), names_to = "col", values_to = "value") %>%
  unite("code" , c("...1", "col"), sep = "") %>%
  mutate(value = str_to_lower(value))

result = input2 %>%
  mutate(value = str_replace_all(`Encrypted Text`,
                                 "([0-9]{2})", 
                                 function(x) {i1$value[i1$code == x]}))

all.equal(result$value, test$`Answer Expected`)
# > [1] TRUE