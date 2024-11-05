library(numbers)
library(tidyverse)

f <- map(1:20, fibonacci)
f[[which.max(map_int(f, ~ sum(as.integer(strsplit(as.character(.x), "")[[1]]))))]]

# 987