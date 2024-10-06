library(tidyverse)
library(readxl)

path = "Excel/125 Morse Code Encoding.xlsx"
  input1 = read_excel(path, range = "A1:A8")
input2 = read_excel(path, range = "D2:I14", col_names = FALSE) %>%
  as.matrix()
test  = read_excel(path, range = "B1:B8")

code = rbind(input2[,1:2], input2[,3:4], input2[,5:6]) %>%
  as.data.frame() %>%
  setNames(c("letter", "code")) %>%
  na.omit() %>%
  rbind(data.frame(letter = " ", code = "\\/"), .) %>%
  mutate(letter = trimws(letter), code = trimws(code))

result = input1 %>%
  mutate(String = toupper(String)) %>%
  mutate(morse = strsplit(String, "") %>%
           map(~code$code[match(.x, code$letter)]) %>%
           map_chr(~paste(.x, collapse = " "))) %>%
  mutate(morse = str_replace_all(morse, "NA", "/")) 

all.equal(result$morse, test$Result)
#> [1] TRUE