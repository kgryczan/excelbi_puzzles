library(tidyverse)
library(readxl)

path <- "300-399/322/322 Employees nearest to average salary.xlsx"
input <- read_excel(path, range = "A1:B20")
test <- read_excel(path, range = "D1:E5")

avg <- round(mean(input$Salary))

result <- input |>
  mutate(diff = abs(Salary - avg), Rank = dense_rank(diff)) |>
  filter(Rank <= 3) |>
  arrange(Rank, Employees) |>
  rename(`Expected Answer` = Employees) |>
  select(Rank, `Expected Answer`)

all.equal(result, test)
# [1] TRUE
