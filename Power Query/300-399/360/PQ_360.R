library(tidyverse)
library(readxl)

path <- "Power Query/300-399/360/PQ_Challenge_360.xlsx"
input <- read_excel(path, range = "A1:B101")
test <- read_excel(path, range = "D1:H8")

result = input %>%
  separate_wider_delim(cols = Log, delim = " | ", names = c("Log", "Emp")) %>%
  separate_longer_delim(cols = Emp, delim = ", ") %>%
  mutate(
    Project = str_extract(Log, "\\[(.*)\\]"),
    hours = str_extract(Log, "\\d+(\\.\\d+)?(?=\\s*(h|hr|hrs))") %>%
      as.numeric()
  ) %>%
  summarise(hours = sum(hours, na.rm = TRUE), .by = c(Emp, Project)) %>%
  arrange(Project) %>%
  pivot_wider(names_from = Project, values_from = hours, values_fill = 0) %>%
  janitor::adorn_totals(c("row", "col")) %>%
  arrange(Emp)

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE
