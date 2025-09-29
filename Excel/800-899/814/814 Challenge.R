library(tidyverse)
library(readxl)

path = "Excel/800-899/814/814 Increasing Alphabets.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10") %>% replace_na(list(`Answer Expected` = ""))

split_increasing = function(s) {
  chars = strsplit(s, "")[[1]]
  idx = cumsum(c(FALSE, diff(utf8ToInt(s)) <= 0))
  tibble(chars, idx) %>%
    group_by(idx) %>%
    summarise(substr = paste0(chars, collapse = ""), .groups = "drop") %>%
    pull(substr) %>%
    discard(~ nchar(.x) < 2) %>%
    paste(collapse = ", ")
}

result = input %>%
  mutate(`Answer Expected` = map_chr(Data, split_increasing)) 

all.equal(result$`Answer Expected`, test$`Answer Expected`)  
# [1] TRUE