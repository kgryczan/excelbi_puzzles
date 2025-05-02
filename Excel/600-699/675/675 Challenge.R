library(tidyverse)
library(readxl)

path = "Excel/675 Permutations with signs.xlsx"
input = read_excel(path, range = "B2:C3")
test  = read_excel(path, range = "B6:C13", col_names = c("Var1", "Var2")) %>% arrange(Var1, Var2)

a = input$num1
b = input$num2 

as = c(a, -a)
bs = c(b, -b)

df = rbind(expand.grid(as, bs), expand.grid(bs, as)) %>% as.data.frame() %>%
  arrange(Var1, Var2)

all.equal(df, test, check.attributes = FALSE)
#> [1] TRUE