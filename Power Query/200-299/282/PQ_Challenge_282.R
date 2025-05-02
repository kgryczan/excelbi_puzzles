library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_282.xlsx"
input1 = read_excel(path, range = "A1:A22")
input2 = read_excel(path, range = "C1:C9")
test = read_excel(path, range = "E1:H4")

result = input1 %>%
  mutate(
    invalid = ifelse(Dept == "Employees" | lag(Dept) == "Employees", 1, 0),
    dept = ifelse(Dept %in% input2$Dept, Dept, NA),
    year = ifelse(str_detect(Dept, "^Y[0-9]{4}$"), Dept, NA)
  ) %>%
  replace_na(list(invalid = 0)) %>%
  filter(invalid == 0) %>%
  fill(dept, year) %>%
  filter(Dept != dept, Dept != year) %>%
  mutate(sdept = sum(as.numeric(Dept), na.rm = TRUE), .by = dept) %>%
  pivot_wider(names_from = year, values_from = Dept) %>%
  arrange(desc(sdept)) %>%
  select(-c(sdept, invalid))
