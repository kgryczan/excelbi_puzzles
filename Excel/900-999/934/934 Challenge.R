library(tidyverse)
library(readxl)


path <- "900-999/934/934 Top Two.xlsx"
input <- read_excel(path, range = "A2:D27")
test <- read_excel(path, range = "F2:G6")

result <- input %>%
  summarise(Hours = sum(Hours), .by = c(EmployeeID, ProjectID)) %>%
  slice_max(Hours, n = 2, with_ties = TRUE, by = ProjectID) %>%
  summarise(`Top 2` = paste(EmployeeID, collapse = ", "), .by = ProjectID)

all.equal(result, test)
# Difference in Project Alpha
