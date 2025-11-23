library(tidyverse)
library(readxl)
library(janitor)

path <- "Power Query/300-399/342/PQ_Challenge_342.xlsx"
input <- read_excel(path, range = "A1:F19")
test  <- read_excel(path, range = "H1:k13")

roll_left <- \(x) c(x[-1], x[1])

left_shift <- \(r) {
  while(r[1] == "" || is.na(r[1])) r <- roll_left(r)
  r
}

df <- input %>%
  split(1:nrow(input)) %>%
  map(~ left_shift(unlist(.x))) %>%
  map_dfr(~ set_names(.x, names(input))) %>%
  remove_empty("cols") 

r1 = df %>%
  filter(row_number() %% 2 == 1) %>%
  select(Group1 = Col1, Group2 = Col2)

r2 = df %>%
  filter(row_number() %% 2 == 0) %>%
  select(Value1 = Col1, Value2 = Col2) %>%
  mutate(across(everything(), as.numeric))

res = bind_cols(r1, r2) %>%
  add_row(Group1 = NA, Group2 = NA, Value1 = NA, Value2 = NA, .before = 4) %>%
  add_row(Group1 = NA, Group2 = NA, Value1 = NA, Value2 = NA, .before = 7) %>%
  add_row(Group1 = NA, Group2 = NA, Value1 = NA, Value2 = NA, .before = 11)

all.equal(res, test, check.attributes = FALSE)
# [1] TRUE
