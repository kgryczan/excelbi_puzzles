library(tidyverse)
library(readxl)

path = "Excel/800-899/845/845 Employee Groups.xlsx"
input = read_excel(path, range = "A2:C14")
test  = read_excel(path, range = "E2:G7") %>%
  mutate(Name = str_replace_all(Name, " , ", ", "))

result = input %>%
  summarise(Name = paste(Name, collapse = ", "),
            .by = c(`Dept ID`,`Emp Ind`)) %>%
  relocate(Name, .after = `Dept ID`) %>%
  arrange(`Dept ID`, `Emp Ind`) 
  

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE
