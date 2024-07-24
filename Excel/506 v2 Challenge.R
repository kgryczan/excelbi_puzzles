library(tidyverse)
library(readxl)

path = "Excel/506 Align Concated Alphabets & Numbers.xlsx"
input = read_excel(path, range = "A1:B6")
test = read_excel(path, range = "C1:C22") %>% pull()

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

zip_and_flatten <- function(list_of_lists) {
  max_length <- max(map_int(list_of_lists, length))
  
  filled_lists <- map(list_of_lists, ~ c(.x, rep(NA, max_length - length(.x))))
  
  flattened <- filled_lists %>% 
    transpose() %>%
    map(unlist) %>%
    unlist() %>%
    discard(is.na)
  
  return(flattened)
}

result = input %>%
  mutate(Numbers = map_chr(Numbers, replace_range) %>% str_split(., ", "),
         Numbers = map2(Alphabets, Numbers, ~ paste(.x, .y, sep = ""))) 

flattened_list <- zip_and_flatten(result$Numbers)

identical(flattened_list, test)
# [1] TRUE
