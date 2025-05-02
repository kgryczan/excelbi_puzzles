library(tidyverse)
library(readxl)

input = read_excel("Excel/375 Students Grades.xlsx", range = "A1:A20")
test  = read_excel("Excel/375 Students Grades.xlsx", range = "B1:B20")


calculate_grade <- function(marks) {
  case_when(
    marks >= 90 & marks <= 100 ~ "A+",
    marks >= 85 & marks < 90  ~ "A",
    marks >= 80 & marks < 85  ~ "A-",
    marks >= 70               ~ ifelse(marks %in% 70:72, "B-", ifelse(marks %in% 73:76, "B", "B+")),
    marks >= 60               ~ ifelse(marks %in% 60:62, "C-", ifelse(marks %in% 63:66, "C", "C+")),
    marks >= 50               ~ ifelse(marks %in% 50:52, "D-", ifelse(marks %in% 53:56, "D", "D+")),
    marks < 50                ~ "F"
  )
}

result = input %>%
  mutate(grade = map(Marks, calculate_grade) %>% unlist())


identical(result$grade, test$`Answer Expected`)
#> [1] TRUE
