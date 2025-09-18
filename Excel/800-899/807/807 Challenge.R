library(tidyverse)
library(readxl)

path = "Excel/800-899/807/807 Fill in With Previous Odd Number.xlsx"
input = read_excel(path, sheet = 2, range = "A2:F10", col_names = FALSE) %>% as.matrix()
test  = read_excel(path, sheet = 2, range = "H2:M10", col_names = FALSE) %>% as.matrix()

df = as.data.frame(as.vector(t(input)))
colnames(df) = "V1"

r1 = df %>%
  mutate(V2 = ifelse(V1 %% 2 == 1, V1, NA)) %>%
  fill(V2) %>%
  mutate(V2 = ifelse(is.na(V1), V2, V1)) %>%
  pull(V2) %>% 
  matrix(nrow = nrow(input), byrow = TRUE)

r1 == test
# one cell is missing in input (with even value)