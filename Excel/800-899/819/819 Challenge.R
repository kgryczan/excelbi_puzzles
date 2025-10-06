library(tidyverse)
library(readxl)
library(hms)

path = "Excel/800-899/819/819 Merging Shifts.xlsx"
input = read_excel(path, range = "A2:D12")
test  = read_excel(path, range = "F2:H8")

merged_shifts = input %>%
  arrange(Emp_No = `Emp No.`, Shift_Num = parse_number(Shift)) %>%
  4%>%
  summarise(Start_Time = first(`Start Time`),
            End_Time   = last(`End Time`), .by = c(Emp_No, group_id)) %>%
  select(-group_id)

all.equal(result, test)
# [1] TRUE