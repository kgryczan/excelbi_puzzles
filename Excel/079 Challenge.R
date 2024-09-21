library(tidyverse)
library(readxl)

path = "Excel/079 Extract Min & Max Numbers.xlsx"
input = read_excel(path, range = "A2:A12")
test  = read_excel(path, range = "B2:C12") %>% replace(is.na(.), 0)

result = input %>%
  mutate(nums = map(Numbers, ~ str_extract_all(., "\\d+"))) %>%
  mutate(nums = map(nums, ~ as.numeric(unlist(.)))) %>%
  mutate(min = map(nums, ~ min(.)),
         max = map(nums, ~ max(.))) %>%
  select(-c(nums, Numbers))

result == test

#       min   max
# [1,]  TRUE  TRUE
# [2,]  TRUE  TRUE
# [3,] FALSE  TRUE
# [4,]  TRUE  TRUE
# [5,]  TRUE  TRUE
# [6,] FALSE  TRUE
# [7,] FALSE FALSE
# [8,]  TRUE  TRUE
# [9,]  TRUE  TRUE
# [10,]  TRUE  TRUE