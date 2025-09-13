library(tidyverse)
library(readxl)

path = "Power Query/300-399/321/PQ_Challenge_321.xlsx"
input = read_excel(path, range = "A1:G8")
test  = read_excel(path, range = "K1:P5") %>%
  mutate(across(everything(), ~ replace_na(.x, "")))

result = input %>%
  summarise(across(starts_with("ID"), 
                   ~ paste0(na.omit(.x), collapse = ", ")), 
            .by = Date)

all_equal(result, test)
# TRUE