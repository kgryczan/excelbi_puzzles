library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_255.xlsx"
input = read_excel(path, range = "A1:C14")
test  = read_excel(path, range = "E1:J4")

result = input %>%
  pivot_wider(names_from = "Task", values_from = "Date Time") %>%
  mutate(across(`2`:`6`, 
                ~if_else(!is.na(.), 
                         round(as.numeric(difftime(., `1`, units = "hours")),2), 
                         NA_real_), 
                .names = "{.col}-1")) %>%
  select(-c(`1`:`6`)) %>%
  rename(Task = Ticket)

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE 