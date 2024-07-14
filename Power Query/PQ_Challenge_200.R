library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_200.xlsx"
input1 = read_excel(path, range = "A1:D6")
input2 = read_excel(path, range = "F1:I6")
test = read_excel(path, range = "A11:E17")

in1 = input1 %>%
  pivot_longer(cols = -c(1), names_to = "subject", values_to = "score")
in2 = input2 %>%
  pivot_longer(cols = -c(1), names_to = "subject", values_to = "score")

result = bind_rows(in1, in2) %>%
  summarise(max = max(score), .by = c("subject", "Student")) %>%
  pivot_wider(names_from = "subject", values_from = "max") %>%
  arrange(Student) 

result = result %>%
  select(Student, sort(names(result)[2:5]))

identical(result, test)
# [1] TRUE