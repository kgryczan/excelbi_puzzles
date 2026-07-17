library(tidyverse)
library(readxl)

path <- "1000-1099/1023/1023 Pivot.xlsx"
input <- read_excel(path, range = "A2:A28", col_names = "Data")
test <- read_excel(path, range = "C2:H8")

result <- input %>%
  separate_wider_delim(Data, names = c("Property", "Value"), delim = ",") %>%
  janitor::row_to_names(1) %>%
  mutate(group = cumsum(Property == "EmployeeID")) %>%
  pivot_wider(names_from = Property, values_from = Value, values_fn = \(x) {
    paste(x, collapse = ", ")
  }) %>%
  select(-group)

all.equal(result, test)
# True
