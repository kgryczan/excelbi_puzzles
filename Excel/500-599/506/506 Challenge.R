library(tidyverse)
library(readxl)

path = "Excel/506 Align Concated Alphabets & Numbers.xlsx"
input = read_excel(path, range = "A1:B6")
test = read_excel(path, range = "C1:C22")

replace_range <- function(input) {
  input %>%
    str_split(", ") %>%
    unlist() %>%
    map_chr(~ if (str_detect(.x, "-")) {
      range <- str_split(.x, "-")[[1]] %>%
        as.numeric()
      paste(seq(range[1], range[2]), collapse = ", ")
    } else {
      .x
    }) %>%
    paste(collapse = ", ")
}

result = input %>%
  mutate(Numbers = map_chr(Numbers, replace_range) %>% str_split(., ", ")) %>%
  unnest_wider(Numbers, names_sep = "_") %>%
  pivot_longer(cols = starts_with("Numbers"), values_to = "Value", names_to = NULL,  cols_vary = "slowest") %>%
  filter(!is.na(Value)) %>%
  unite("Expected Answer", c("Alphabets", "Value"), sep = "") %>%
  select("Expected Answer")

identical(result$`Expected Answer`, test$`Expected Answer`)
# [1] TRUE  
