library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_218.xlsx"
input = read_excel(path, range = "A1:C17")
test  = read_excel(path, range = "E1:G5") %>%
  replace_na(list(`Completed Tasks` = "", `Not Completed Tasks` = ""))

result = input %>%
  mutate(has_date = ifelse(is.na(`Completion Date`), "Not Completed Tasks", "Completed Tasks")) %>%
  select(-`Completion Date`) %>%
  pivot_wider(names_from = has_date, values_from = Tasks, values_fn = list) %>%
  mutate(`Completed Tasks` = map_chr(`Completed Tasks`, ~paste(.x, collapse = ", ")),
         `Not Completed Tasks` = map_chr(`Not Completed Tasks`, ~paste(.x, collapse = ", "))) 

identical(result, test)
#> [1] TRUE