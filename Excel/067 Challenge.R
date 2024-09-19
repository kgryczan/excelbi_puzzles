library(tidyverse)
library(readxl)

path = "Excel/067 First Ladies Same Surname.xlsx"
input = read_excel(path, range = "A1:A48")
test  = read_excel(path, range = "B1:B15")

result = input %>%
  extract(`First Ladies`, into = c("first_names", "surname"), 
          regex = "^([\\w]+(?:\\s[\\w]+)?)\\s([\\w]+)$", remove = FALSE) %>%
  mutate(n_by_sur = n(), .by = surname) %>%
  filter(n_by_sur > 1) %>%
  arrange(surname, first_names) %>%
  select(`First Ladies`)

identical(result$`First Ladies`, test$`Answer Expected`)
#> [1] TRUE