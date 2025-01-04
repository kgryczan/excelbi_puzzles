library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_249.xlsx"
input = read_excel(path, range = "A1:C7")
test  = read_excel(path, range = "A11:E14")

r1 = input %>%
  mutate(rn = row_number(), .by = Class) %>%
  select(-Marks) %>%
  pivot_wider(names_from = rn, values_from = Student, names_glue = "Student{rn}") 

r2 = input %>%
  summarise(`Best Student` = paste0(Student, collapse = ", "), .by = c(Class, Marks)) %>%
  slice_max(order_by = Marks, n = 1, by = Class) %>%
  select(-Marks)

result = r1 %>%
  left_join(r2, by = "Class")

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE