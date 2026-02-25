library(tidyverse)
library(readxl)

path <- "Excel/900-999/921/921 Pass Fail.xlsx"
input1 <- read_excel(path, range = "A1:C16")
input2 <- read_excel(path, range = "E1:F6")
test  <- read_excel(path, range = "E10:G13")

result = input1 %>%
  left_join(input2, by = "Subject") %>%
  mutate(Pass = ifelse(Marks < `Passing Marks`, "Fail Subjects", "Pass Subjects")) %>%
  pivot_wider(id_cols = Student, names_from = Pass, values_from = Subject, values_fn = list(Subject = ~paste(.x, collapse = ", ")))

all.equal(result, test)
#> [1] TRUE