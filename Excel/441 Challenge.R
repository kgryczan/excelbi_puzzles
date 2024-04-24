library(tidyverse)
library(readxl)

input = read_excel("Excel/441 Integer Intervals.xlsx", range = "A1:A7")
test  = read_excel("Excel/441 Integer Intervals.xlsx", range = "B1:B7")

result = input %>%
  mutate(rn = row_number()) %>%
  separate_rows(Problem, sep = ", ") %>%
  mutate(Problem = map(Problem, ~{
    if(str_detect(., "-")){
      range = str_split(., "-")[[1]]
      seq(as.numeric(range[1]), as.numeric(range[2]))
    } else {
      as.numeric(.)
    }
  })) %>%
  unnest(Problem) %>%
  summarise(`Answer Expected` = str_c(sort(unique(Problem)), collapse = ", "), .by = rn) %>%
  select(-rn)

identical(result, test)
# [1] TRUE
