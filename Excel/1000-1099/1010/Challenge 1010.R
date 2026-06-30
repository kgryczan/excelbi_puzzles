library(tidyverse)
library(readxl)

path <- "1000-1099/1010/1010 Record Alignment.xlsx"
input <- read_excel(path, range = "A2:A24")
test <- read_excel(path, range = "C2:E7")

result <- input %>%
  mutate(count = cumsum(is.na(input[[1]])) + 1) %>%
  na.omit() %>%
  mutate(nr = row_number(), .by = count) %>%
  mutate(
    adj_nr = case_when(nr == 3 & !str_detect(Data, "\\d") ~ 4, TRUE ~ nr)
  ) %>%
  select(-c(nr)) %>%
  pivot_wider(names_from = adj_nr, values_from = Data) %>%
  select(-count) %>%
  unite("Full Name", c(`1`, `2`), sep = " ", na.rm = TRUE) %>%
  mutate(`3` = as.numeric(`3`)) %>%
  select(`Full Name`, Age = `3`, City = `4`)

all.equal(result, test)
# True
