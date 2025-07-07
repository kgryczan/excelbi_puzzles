library(tidyverse)
library(readxl)

path = "Excel/700-799/754/754 Table Transformation.xlsx"
input = read_excel(path, range = "A2:B18")
test  = read_excel(path, range = "D2:G6")

result = input %>%
  mutate(across(everything(), ~str_remove_all(.x, ",") %>% str_trim()),
         row_id = row_number(),
         grp    = (row_id - 1) %/% 4 + 1,
         pos    = (row_id - 1) %% 4 + 1) %>%
  group_by(grp) %>%
  summarise(
    key   = c(Data1[pos == 1], Data2[pos == 1], Data2[pos == 3]),
    value = c(Data1[pos == 2], Data2[pos == 2], Data1[pos == 4]),
    .groups = "drop"
  ) %>%
  pivot_wider(names_from = key, values_from = value) %>%
  replace_na(list(Salary = "", Age = "")) %>%
  mutate(across(c(Salary, Age), as.numeric)) %>%
  select(Employee, Dept, Salary, Age)

all.equal(result, test)
# > [1] TRUE
