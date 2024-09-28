library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_221.xlsx"
input = read_excel(path, range = "A1:C20")
test  = read_excel(path, range = "E1:J20")

result = input %>%
  mutate(Project_Index = as.numeric(as.factor(Project))) %>%
  mutate(Task_Index = as.numeric(paste0(Project_Index,".",as.numeric(as.factor(Task)))) , .by = Project) %>%
  mutate(Activity_Index = paste0(Task_Index,".", as.numeric(as.factor(Activity))), .by = c(Project, Task)) 

all.equal(result, test)
# [1] TRUE          