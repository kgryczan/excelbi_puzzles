library(readxl)
library(tidyxl)
library(dplyr)
library(purrr)

data <- read_excel(file_path)

file_path <- "Pair and Sort.xlsx"

cell_colors <- xlsx_cells(file_path) %>%
  filter(sheet == "Sheet1", 
         row > 1,
         col == 1) %>% 
  select(row, local_format_id)

check = data %>% 
  select(expected_answer = 2)

result = data %>%
  mutate(row = row_number()) %>%
  left_join(cell_colors %>% mutate(row = row -1), by = c("row")) %>%
  select(Names, local_format_id) %>%
  arrange(local_format_id, Names)%>%
  select(my_answer = Names)

test = bind_cols(check, result) %>%
  mutate(test = check == result)