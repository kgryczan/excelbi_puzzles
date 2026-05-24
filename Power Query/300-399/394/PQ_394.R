library(tidyverse)
library(readxl)

path <- "300-399/394/PQ_Challenge_394.xlsx"
input <- read_excel(path, range = "A1:A26", col_names = FALSE)
test <- read_excel(path, range = "C1:F10")

result = input %>%
  separate_wider_delim(...1, delim = ",", names = colnames(test)) %>%
  janitor::row_to_names(1) %>%
  mutate(Marks = as.numeric(Marks)) %>%
  filter(Marks == max(Marks), .by = c(Class, Subject)) %>%
  add_count(Class, StudentID, name = "top_subjects") %>%
  filter(top_subjects == max(top_subjects), .by = Class) %>%
  select(StudentID, Class, Subject, Marks)

all.equal(result, test)
# [1] TRUE
