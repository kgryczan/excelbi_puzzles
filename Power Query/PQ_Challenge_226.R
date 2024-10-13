library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_226.xlsx"
input = read_excel(path, range = "A1:D13")
test  = read_excel(path, range = "F1:I19")

result = input %>%
  fill(`Dept ID`) %>%
  select(-`Highest Paid Employee`) %>%
  pivot_longer(-`Dept ID`, values_to = "Value") %>%
  separate(Value, into = c("Emp Names", "Salary", "Promotion Date"), sep = "-") %>%
  select(-name) %>%
  filter(!is.na(`Emp Names`)) %>%
  arrange(`Dept ID`, `Emp Names`) %>%
  mutate(`Promotion Date` = as.POSIXct(`Promotion Date`, format = "%m/%d/%Y", tz = "UTC"),
         Salary = as.numeric(Salary)) %>%
  select(`Dept ID`, `Emp Names`, `Promotion Date`, Salary)

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE