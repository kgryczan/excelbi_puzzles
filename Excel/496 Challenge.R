library(tidyverse)
library(readxl)

path = "Excel/496 Sum Marks.xlsx"
input = read_excel(path, range = "A2:B7")
test  = read_excel(path, range = "D2:E6")

result = input %>%
  separate_rows(Subjects, sep = ", ") %>%
  separate(Subjects, into = c("Subjects", "Marks"), sep = "(?<=\\D)(?=\\d)") %>%
  mutate(Subjects = str_remove_all(Subjects, "[^[:alpha:]]")) %>%
  summarise(Total = sum(as.numeric(Marks)), .by = Subjects) %>%
  arrange(Subjects)

identical(result, test)
#> [1] TRUE