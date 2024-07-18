library(tidyverse)
library(readxl)

path = "Excel/502 Remove Minimum Digits to Make a Cube.xlsx"
input = read_excel(path, range = "A2:A10")
test  = read_excel(path, range = "B2:C10")

cube_number <- function(number) {
  str_nums <- str_split(as.character(number), "")[[1]]
  digits_combinations <- map(1:(length(str_nums) - 1), ~combn(str_nums, ., simplify = FALSE))
  all_combinations <- flatten(digits_combinations) %>% map_chr(~paste(.x, collapse = ""))
  
  cube <- keep(all_combinations, ~ round(as.numeric(.x)^(1/3))^3 == as.numeric(.x)) %>% 
    as.numeric() %>% 
    max(., na.rm = TRUE, finite = TRUE)
  
  if (!is.na(cube)) {
    digits_left <- setdiff(str_nums, str_split(as.character(cube), "")[[1]])
    unique_digits <- unique(digits_left)
    return(list(unique_digits, cube))
  } else {
    return(list("", ""))
  }
}

result <- input %>%
  mutate(result = map(Numbers, cube_number)) %>%
  mutate(`Removed Digits` = map_chr(result, ~ pluck(.x, 1) %>% sort(.) %>% paste(collapse = ", ")),
         `Cube Number` = map_chr(result, ~ pluck(.x, 2) %>% as.character)) %>%
  mutate(`Removed Digits` = if_else(nchar(Numbers) == str_count(`Removed Digits`, "\\d"), NA, `Removed Digits`),
         `Cube Number` = if_else(`Removed Digits` == "", NA, as.numeric(`Cube Number`))) %>%
  select(-c(result, Numbers))

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE
