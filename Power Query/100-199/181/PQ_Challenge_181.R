library(tidyverse)
library(openxlsx2)

file_path = "Power Query/PQ_Challenge_181.xlsx"

input = wb_read(file_path, col_names = FALSE, rows = 1:11, cols = "A:D")
test  = wb_read(file_path, col_names = TRUE, rows = 1:20, cols = "F:I")


result = input %>%
  mutate(Date = ifelse(str_detect(A, "\\d"), A, NA)) %>%
  fill(Date) %>%
  set_names(c("Name", "Data1", "Data2", "Data3", "Date")) %>%
  pivot_longer(-c("Name","Date"), names_to = "Data", values_to = "Value") %>%
  mutate(Date = ifelse(str_detect(Date, ".*\\d{4}$"), mdy(Date), ymd(Date)) %>% as.Date(),
         Value = as.numeric(Value)) %>%
  na.omit() %>%
  select(2,1,3,4)

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE