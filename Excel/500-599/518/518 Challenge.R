library(tidyverse)
library(readxl)

path = "Excel/518 Rank Students.xlsx"
input = read_excel(path, range = "A1:B20")
test  = read_excel(path, range = "C1:C20")

input$Grades <- factor(input$Grades, 
                       levels = c("A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+", "D", "D-"), 
                       ordered = TRUE)

result <- input %>% 
  mutate(rank = ifelse(Grades == "F", 
                       NA, 
                       as.numeric(dense_rank(Grades))))

identical(result$rank, test$`Answer Expected`)
# [1] TRUE