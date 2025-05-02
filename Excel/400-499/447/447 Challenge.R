library(gtools)
library(tictoc)
library(tidyverse)
library(readxl)

test = read_excel("Excel/447 Penholodigital Squares.xlsx", range = "A1:A31")
test$`Answer Expected` = as.numeric(test$`Answer Expected`)

# Approach 1
tic()
penholodigital_numbers <- apply(permutations(9, 9, 1:9, set = FALSE), 1, function(x) {
  num <- as.numeric(paste0(x, collapse = ""))
  root <- sqrt(num)
  if (root == floor(root)) num else NA
})
penholodigital_numbers <- na.omit(penholodigital_numbers)
toc() # 3.59 sec


# Validation
p1 = penholodigital_numbers %>%
  tibble(`Answer Expected` = .)
attributes(p1$`Answer Expected`) <- NULL
  

identical(p1$`Answer Expected`, test$`Answer Expected`)
# [1] TRUE

---------------------------------------------

# Approach 2
tic()
penholodigital_numbers2 = permutations(9,9,1:9) %>%
  as_tibble() %>%
  unite(num, V1:V9, sep = "") %>%
  mutate(num = as.numeric(num)) %>%
  filter(sqrt(num) == floor(sqrt(num)))
toc() # 3.3 sec

# Validation
identical(penholodigital_numbers2$num, test$`Answer Expected`)
# [1] TRUE


