library(tidyverse)
library(readxl)

path = "Excel/696 Pass or Fail.xlsx"
input = read_excel(path, range = "A2:C18")
test = read_excel(path, range = "E3:F7", col_names = c("Student", "Result"))

result = input %>%
  pivot_wider(names_from = Subject, values_from = Pass, values_fill = "Y") %>%
  mutate(Result = if_else((Maths == "Y" | Science == "Y") & English == "Y" & Philosophy == "Y", 
                          "Pass", "Fail")) %>%
  select(Student, Result) %>%
  arrange(Student)

all.equal(result, test)
