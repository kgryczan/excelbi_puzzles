library(tidyverse)
library(readxl)

path <- "Excel/900-999/904/904 Grades.xlsx"
input <- read_excel(path, range = "A1:B21")
test <- read_excel(path, range = "C1:C21")

grade_student <- function(x) {
  if (sum(x < 60) >= 2) {
    "F"
  } else {
    cut(
      mean(sort(x, decreasing = TRUE)[1:3]),
      c(-Inf, 60, 70, 80, 90, Inf),
      labels = c("F", "D", "C", "B", "A"),
      right = FALSE
    )
  }
}

result = input %>%
  separate_longer_delim(`Subject Marks`, delim = "; ") %>%
  separate_wider_delim(
    `Subject Marks`,
    delim = ":",
    names = c("Subject", "Marks")
  ) %>%
  mutate(Marks = as.numeric(Marks)) %>%
  group_by(Student_ID) %>%
  mutate(Grade = grade_student(Marks)) %>%
  summarise(Grade = first(Grade))

all.equal(result$Grade, test$Final_Grade)
# [1] TRUE
