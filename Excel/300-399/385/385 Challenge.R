library(tidyverse)
library(readxl)

test = read_excel("Excel/385 Generate the Grid.xlsx", range = "C3:L12", col_names = FALSE) %>%
  as.matrix() %>%
  {attr(., "dimnames") <- NULL; .}

generate = function(n){
  grid_df <- expand.grid(i = 1:n, j = 1:n) %>% 
    mutate(value = (i + j - 2) %% n) %>%
    pull(value)
  
  matrix(grid_df, nrow = n, ncol = n)
}

a = generate(5)

b = a + 5

c = cbind(a,b)
d = cbind(b,a)

result = rbind(c,d) %>% {attr(., "dimnames") <- NULL; .}
  

identical(result, test)
# [1] TRUE
  
