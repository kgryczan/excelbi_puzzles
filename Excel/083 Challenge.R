library(tidyverse)
library(readxl)

path = "Excel/083 Generate Output from Strings.xlsx"
input = read_excel(path, range = "A1:A14")
test  = read_excel(path, range = "B1:C6") %>% replace(is.na(.), "")
colnames(test) = c("letter", "number")

result = input %>%
  separate(Data, into = c("letter", "number"), sep = "-") %>%
  summarise(number = str_c(sort(unique(as.numeric(number))), collapse = ", "), .by = letter) 

identical(result, test)
#> [1] TRUE