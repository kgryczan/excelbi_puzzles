library(tidyverse)
library(readxl)

path = "Excel/020 Highest Score Subjects Wise.xlsx"
input = read_excel(path, range = "A1:C20")
test  = read_excel(path, range = "E2:G6")

result = input %>%
  mutate(rank = dense_rank(desc(Marks)), .by = Subjects) %>%
  filter(rank == 1) %>%
  summarise(Student = str_c(Student, collapse = ", "), .by = c(Subjects, Marks)) %>%
  select(Subjects, Student, Marks) %>%
  arrange(Subjects)

identical(result, test)
# [1] TRUE