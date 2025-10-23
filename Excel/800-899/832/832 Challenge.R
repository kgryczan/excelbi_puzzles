library(tidyverse)
library(readxl)

path = "Excel/800-899/832/832 Delete Characters Around Asterisks.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10") %>%
  mutate(`Answer Expected` = replace_na(`Answer Expected`, ""))

result = input %>%
  mutate(result = str_remove_all(String, "(?<=\\*).|.(?=\\*)|\\*"))

all.equal(test$`Answer Expected`, result$result, check.attributes = F)
