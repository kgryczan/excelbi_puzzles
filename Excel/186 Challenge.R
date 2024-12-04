library(tidyverse)
library(readxl)

path = "Excel/186 Less Odd Even.xlsx"
input = read_excel(path, range = "A1:A7")
test  = read_excel(path, range = "B1:B7") %>% replace_na(list(`Answer Expected` = ""))

split_numbers = function(x){
  x = strsplit(x, ", ")[[1]]
  x = as.numeric(x)
  odd = sum(x %% 2 == 1)
  even = sum(x %% 2 == 0)
  if(odd > even){
    return(paste(x[x %% 2 == 0], collapse = ", "))
  } else if(even > odd){
    return(paste(x[x %% 2 == 1], collapse = ", "))
  } else {
    return("")
  }
}

result = input %>%
  mutate(result = map_chr(Numbers, split_numbers))

all.equal(result$result, test$`Answer Expected`, check.attributes = FALSE)
#> [1] TRUE