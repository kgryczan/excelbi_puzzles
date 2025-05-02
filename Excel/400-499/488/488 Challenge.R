library(gtools)
library(tidyverse)
library(readxl)

path = "Excel/488 Numbers to Meet Target Sum.xlsx"
input = read_excel(path, range = "A1:A10")
target = read_excel(path, range = "B1:B2") %>% pull()
test = read_excel(path, range = "C1:C5")


find_combinations <- function(numbers, target) {
  combs <- map(1:length(numbers), ~combinations(length(numbers), ., v = numbers))
  valid_combs <- combs %>%
     map(as_tibble) %>%
    bind_rows() %>%
    mutate(sum = rowSums(., na.rm = TRUE)) %>%
    filter(sum == target)
  
  return(valid_combs)
}

combinations <- find_combinations(input$Numbers, target) %>%
  unite("Combination", - sum, sep = ", ", remove = T, na.rm = T) 

sort_numbers <- function(numbers) {
  paste(sort(as.numeric(strsplit(numbers, ",")[[1]])), collapse = ", ")
}

test <- test %>%
  mutate(Combination = map_chr(`Answer Expected`, sort_numbers))

identical(sort(combinations$Combination), sort(test$Combination))
# [1] TRUE