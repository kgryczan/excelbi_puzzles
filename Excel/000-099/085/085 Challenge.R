library(tidyverse)
library(readxl)

path = "Excel/085 Missing Subjects.xlsx"
input = read_excel(path, range = "A1:C11")
test  = read_excel(path, range = "E2:F4")

result1 = input %>%
  separate_rows(Subjects, sep = ", ") %>%
  summarise(subs = list(unique(sort(Subjects))), .by = Gender)

male_s = result1 %>%
  filter(Gender == "Male") %>%
  pull(subs[[1]])
female_s = result1 %>%
  filter(Gender == "Female") %>%
  pull(subs[[1]])

m_diff = setdiff(male_s[[1]], female_s[[1]])
f_diff = setdiff(female_s[[1]], male_s[[1]])

result2 = result1 %>%
  mutate(`Missing Subjects` = case_when(
    Gender == "Male" ~ paste(m_diff, collapse = ", "),
    Gender == "Female" ~ paste(f_diff, collapse = ", ")
  )) %>%
  select(-subs)

identical(result2, test)
# [1] TRUE