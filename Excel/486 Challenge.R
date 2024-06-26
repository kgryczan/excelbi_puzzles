library(tidyverse)
library(readxl)

path = "Excel/486 Create Integer Intervals.xlsx"
input = read_excel(path, range = "A1:A8")
test  = read_excel(path, range = "B1:B8")

group_consecutive = function(number_string) {
  numbers <- str_split(number_string, ",") %>%
    unlist() %>%
    as.numeric()
  
  tibble(numbers = sort(numbers)) %>%
    mutate(group = cumsum(c(TRUE, diff(numbers) != 1))) %>%
    summarise(range = if_else(n() > 1, 
                              paste0(min(numbers), "-", max(numbers)), 
                              as.character(numbers[1])), .by = group) %>%
    pull(range) %>%
    paste(collapse = ", ")
}

result = input %>%
  mutate(`Answer Expected` = map_chr(Problem, group_consecutive))

identical(result$`Answer Expected`, test$`Answer Expected`)
#> [1] TRUE