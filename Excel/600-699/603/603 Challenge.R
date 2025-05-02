library(tidyverse)
library(readxl)

path = "Excel/603 Missing Numbers.xlsx"
input = read_excel(path, range = "A2:C5", col_names = F) %>% as.matrix()
test  = read_excel(path, range = "E1:E6")

V1 = input %>%
  as.vector() 
V2 = min(V1):max(V1)

result = data.frame(nums = setdiff(V2, V1)) %>%
  mutate(group = cumsum(c(1, diff(nums) != 1))) %>%
  summarise(nums = ifelse(n() > 1, 
                          paste0(min(nums), "-", max(nums)), 
                          as.character(nums)), .by = group) 

all.equal(result$nums, test$`Answer Expected`)
#> [1] TRUE