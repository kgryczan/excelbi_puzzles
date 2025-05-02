library(tidyverse)
library(readxl)

path = "Excel/180 Maximum Items Purchased.xlsx"
input = read_excel(path, range = "A1:B10")
test  = read_excel(path, range = "D1:D6")

input$Items = as.factor(input$Items)

sequences = expand.grid(rep(list(0:1), 9)) %>%
  t() %>%
  as_tibble()

s2 = input %>% bind_cols(sequences) %>%
  mutate(across(V1:V512, ~ . * `Cost ($)`)) %>%
  t() %>%
  as_tibble() %>%
  set_names(.[1,]) %>%
  slice(-1) %>%
  mutate(across(everything(), as.numeric)) %>%
  mutate(Total = rowSums(.),
         Count = rowSums(. != 0)) %>%
  filter(Total <= 150) %>%
  slice_max(Count, n = 1) %>%
  select(-Total, -Count) %>%
  transpose() %>%
  unlist()

s3 = names(s2[s2 != 0]) %>% tibble(`Answer Expected` = .)

all.equal(s3, test)
#> [1] TRUE
