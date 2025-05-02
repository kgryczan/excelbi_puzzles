library(tidyverse)
library(readxl)
library(gt)

path = "Power Query/PQ_Challenge_215.xlsx"
input = read_excel(path, range = "A1:E20")
test  = read_excel(path, range = "G1:J15")

result = input %>%
  mutate(out_day = case_when(
    !is.na(`Paid Date`) ~ NA_real_,
    `Due Date` > today() ~ 0,
    TRUE ~ as.numeric(difftime(today(), `Due Date`, units = "days"))
  )) %>%
  filter(!is.na(out_day)) %>%
  arrange(`Branch ID`, Customer, `Due Date`) %>%
  select(-`Paid Date`) %>%
  group_by(`Branch ID`)  %>%
  gt() %>%
  # change column names
  cols_label(Customer = "Branch ID / Customer",
             `Due Date` = "Due Date",
            `Loan Amt` = "Total Loan Amount",
             out_day = "Total Outstanding Days") 

result

