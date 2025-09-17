library(tidyverse)
library(readxl)

path = "Excel/800-899/806/806 Extract Aadhar and PAN.xlsx"
input = read_excel(path, range = "A2:B11")
test  = read_excel(path, range = "C2:D11")

result = input %>%
  mutate(Aadhar = str_extract(Strings, "\\d{12}") %>% as.numeric(),
         PAN = str_extract(Strings, "[A-Z]{5}\\d{4}[A-Z]")) %>%
  select(-c(Strings, Names))

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE