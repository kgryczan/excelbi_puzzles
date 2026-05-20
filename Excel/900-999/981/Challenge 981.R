library(tidyverse)
library(readxl)

path <- "900-999/981/981 Running Max.xlsx"
input <- read_excel(path, range = "A1:D26")
test <- read_excel(path, range = "E1:E26")

result <- input %>%
  mutate(ResetGroup = cumsum(ResetFlag), .by = Category) %>%
  mutate(RunningMax = cummax(Amount), .by = c(Category, ResetGroup)) %>%
  select(-ResetGroup)

all.equal(result$RunningMax, test$`Answer Expected`)
# [1] TRUE
