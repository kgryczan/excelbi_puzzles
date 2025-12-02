library(tidyverse)
library(readxl)

path <- "Excel/800-899/860/860 Splitting Into Lines.xlsx"
input <- read_excel(path, range = "A1:B2")
test <- read_excel(path, range = "C3:D9", col_names = c("Line", "count"))

output <- str_wrap(input$Text, width = input$`Limit Len`) %>%
  str_split("\n") %>%
  unlist() %>%
  as_tibble() %>%
  mutate(count = str_length(value) %>% as.numeric()) %>%
  rename(Line = value)

all_equal(output, test)
# [1] TRUE
