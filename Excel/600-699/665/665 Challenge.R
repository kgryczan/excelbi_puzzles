library(tidyverse)
library(readxl)

path = "Excel/665 Bi & Trimorphic Numbers.xlsx"
test  = read_excel(path, range = "A1:A10")

# Only 1, 5, 6 and 0 squared and cubed give us the same digit at the end. 
# so we can decrease the search scope.

df = data.frame(n = 1:100000) %>% 
  filter(n %% 10 %in% c(0, 1, 5, 6)) %>%
  mutate(n2 = n^2, n3 = n^3) %>%
  filter(str_ends(as.character(n2), as.character(n)), 
         str_ends(as.character(n3), as.character(n)))

all.equal(df$n, test$`Expected Answer`)
#> [1] TRUE