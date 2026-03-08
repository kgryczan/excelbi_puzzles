library(tidyverse)
library(readxl)

path <- "300-399/372/PQ_Challenge_372.xlsx"
input <- read_excel(path, range = "A1:D51")
test <- read_excel(path, range = "G1:I8")

result = input %>%
  mutate(`Total Hours` = sum(Hours), .by = Employee) %>%
  mutate(HorPerProject = sum(Hours), .by = c(Employee, Project)) %>%
  filter(HorPerProject == max(HorPerProject), .by = Employee) %>%
  select(Employee, Project, `Total Hours`) %>%
  distinct() %>%
  summarise(
    `Top Project` = paste(sort(Project), collapse = ", "),
    `Total Hours` = first(`Total Hours`),
    .by = Employee
  ) %>%
  arrange(Employee) %>%
  janitor::adorn_totals("row", fill = NA)

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE
