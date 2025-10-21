library(tidyverse)
library(readxl)

path = "Excel/800-899/830/830 Transpose.xlsx"
input = read_excel(path, range = "A2:B20")
test  = read_excel(path, range = "D2:F7")

result = input %>%
  mutate(type = ifelse(Data1 == "Type", Data2, NA_character_),
         Student = ifelse(Data1 == "Student", Data2, NA_character_)) %>%
  fill(type, Student) %>%
  filter(!(Data1 %in% c("Type", "Student"))) %>%
  select(-type) %>%
  pivot_wider(names_from = Data1, values_from = Data2) %>%
  mutate(Marks = as.numeric(Marks)) %>%
  arrange(desc(Marks), Student)

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE