library(tidyverse)
library(readxl)

path = "Excel/584 Cross Product.xlsx"
input = read_excel(path, range = "A1:B5")
test  = read_excel(path, range = "D1:D49") %>% arrange(`Answer Expected`)

result = expand.grid(input$Column1, input$Column2) %>%
  mutate(comb = paste0(str_extract(Var1, "[A-Z]"), str_extract(Var2, "[A-Z]")),
         num = as.numeric(str_extract(Var1, "[0-9]")) * coalesce(as.numeric(str_extract(Var2, "[0-9]")),0)) %>%
  uncount(num) %>%
  arrange(comb) %>%
  select(`Answer Expected` = comb)

all.equal(result, test, check.attributes = FALSE)  
#> [1] TRUE