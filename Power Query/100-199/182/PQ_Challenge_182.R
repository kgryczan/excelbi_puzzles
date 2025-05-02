library(tidyverse)
library(openxlsx2)

path = "Power Query/PQ_Challenge_182.xlsx"


input = wb_read(path, rows = 1:20, cols = "A:D")
test  = wb_read(path, rows = 1:11, cols = "F:I", col_names = FALSE, detect_dates = TRUE) %>%
  mutate(`F` = str_replace(`F`, "5/1/2014", "2014-05-01"))

result = input %>%
  pivot_wider( names_from = "Data", values_from = "Value") %>%
  mutate(rn = row_number())

r1 = result %>%
  summarise(Name = format(Date), Data1 = "Data1", Data2 = "Data2", Data3 = "Data3", rn = 0, .by = Date) %>%
  distinct()

r2 = result %>%
  rbind(r1) %>%
  arrange(Date, rn) %>%
  select(-c(Date, rn))

colnames(r2) = colnames(test)

all.equal(r2, test, check.attributes = FALSE)
# [1] TRUE