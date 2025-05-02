library(tidyverse)
library(readxl)

path = 'Power Query/PQ_Challenge_209.xlsx'
input1 = read_excel(path, range = "A2:C10")
input2 = read_excel(path, range = "A13:C17")
test  = read_excel(path, range = "F1:J5") %>%
  mutate(across(-1, as.Date))

i1 = input1 %>%
  mutate(process_part = row_number(), .by = Process) %>%
  separate_rows(Task, sep = ", ") %>%
  left_join(input2, by = c("Task")) %>%
  mutate(max_dur = max(`Duration Days`, na.rm = T),
         end_date = as.Date(`Start Date`) + max_dur, 
         .by = c(Process, process_part)) %>%
  select(Owner, Process, end_date) %>%
  pivot_wider(names_from = Owner, values_from = end_date) %>%
  select(Process, Anne, Lisa, Nathan, Robert)

identical(i1, test)
# [1] TRUE
