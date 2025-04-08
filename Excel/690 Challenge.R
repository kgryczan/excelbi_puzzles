library(tidyverse)
library(readxl)

path = "Excel/690 Alphabets Grid Sum.xlsx"
input = read_excel(path, range = "A2:J12", col_names = FALSE) %>% as.matrix()
test  = read_excel(path, range = "L1:M23")

M = input %>%
  t() %>%
  matrix(ncol = 2, byrow = TRUE) %>%
  as.data.frame() %>%
  mutate(V2 = as.numeric(V2)) %>%
  summarise(V2 =  sum(V2), .by = V1) %>%
  arrange(V1) %>%
  select(Alphabets = V1, Sum = V2) 

all.equal(M, test, check.attributes = FALSE) 
# [1] TRUE