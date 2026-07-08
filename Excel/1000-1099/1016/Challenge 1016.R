library(tidyverse)
library(readxl)

path <- "1000-1099/1016/1016 Shift Duration.xlsx"
input <- read_excel(path, range = "A2:D13")
test <- read_excel(path, range = "F2:H6")

result <- input %>%
  fill(Employee, Date) %>%
  mutate(Duration = ifelse(Category == "Break", Duration * -1, Duration)) %>%
  summarize(Duration = sum(Duration, na.rm = T), .by = c(Employee, Date))

all.equal(test, result)
# True
