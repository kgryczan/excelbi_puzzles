library(tidyverse)
library(readxl)
library(openxlsx2)

input = read_excel("Power Query/PQ_Challenge_165.xlsx", range = "A1:C11") %>%
  fill(everything(), .direction = "down") %>%
  mutate(`Max Bonus` = Salary * 0.1)

wb = wb_workbook() %>%
  wb_add_worksheet(name = "Sheet1") %>%
  wb_add_data(x = input)

df <- wb_data(wb, sheet = 1)

wb = wb %>%
  wb_add_pivot_table(
    df, 
    dims = "F1",
    rows = c("Dept", "Emp"),
    data = c("Emp", "Salary", "Max Bonus" ),
    fun  = c("count", "sum", "sum")
  )

wb_open(wb)
