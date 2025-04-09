library(tidyverse)
library(readxl)

path = "Excel/220 Max Matrix Sum.xlsx"
input = read_excel(path, range = "A1:P16")
test  = read_excel(path, range = "R2:S5")

res = input %>%
  column_to_rownames("...1") %>%
  as.matrix()

r1 = res %>% rowSums()

r2 = res %>% t() %>%  rowSums()

df1 = t(r1) %>% t() %>% as.data.frame()
df2 = t(r2) %>% t() %>% as.data.frame()
df = bind_rows(df1, df2) %>%
  rownames_to_column("row") %>%
  slice_max(order = V1, n = 3) %>%
  summarise(
    row = paste(row, collapse = ", "),
    V1 = first(V1),
    .by = V1
  ) %>%
  select(Headers = row, Total = V1) 

all.equal(df, test, check.attributes = FALSE)
#> [1] TRUE