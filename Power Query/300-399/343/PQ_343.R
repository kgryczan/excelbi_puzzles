library(tidyverse)
library(readxl)
library(unpivotr)

path <- "Power Query/300-399/343/PQ_Challenge_343.xlsx"
input <- read_excel(path, range = "A1:B19")
test <- read_excel(path, range = "D1:H6")

result <- input %>%
  mutate(group = cumsum(Data1 == "Dept")) %>%
  filter(group > 0) %>%
  group_by(group) %>%
  group_modify(
    ~ {
      emp_rows <- which(.x$Data1 == "Emp ID") + 1
      salary_rows <- which(.x$Data1 == "Salary") + 1
      n_emps <- salary_rows[1] - emp_rows[1]

      tibble(
        Dept = .x$Data1[2],
        Emp_ID = .x$Data1[emp_rows:(emp_rows + n_emps - 1)],
        Location = .x$Data2[emp_rows:(emp_rows + n_emps - 1)],
        Salary = as.numeric(.x$Data1[salary_rows:(salary_rows + n_emps - 1)]),
        Age = as.numeric(.x$Data2[salary_rows:(salary_rows + n_emps - 1)])
      )
    }
  ) %>%
  ungroup() %>%
  select(-group) %>%
  na.omit()

all.equal(result, test, check.attributes = FALSE)
