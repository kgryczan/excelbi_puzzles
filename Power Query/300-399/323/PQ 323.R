library(tidyverse)
library(readxl)

path = "Power Query/300-399/323/PQ_Challenge_323.xlsx"
input = read_excel(path, range = "A1:A4")
test  = read_excel(path, range = "C1:F9")

d = input %>%
  transpose() %>%
  as.data.frame()
processed_cols = map(1:3, ~ {
  d %>%
    select(.x) %>%
    separate_longer_delim(names(.)[1], ", ")
})

d1 = processed_cols[[1]] %>%
  mutate(Group = ifelse(str_detect(Data, "Group"), Data, NA)) %>%
  fill(Group) %>%
  filter(!str_detect(Data, "Group")) %>%
  nest_by(Group)
d2 = processed_cols[[2]]
d3 = processed_cols[[3]]

result = d1 %>%
  bind_cols(d3) %>%
  unnest(cols = data) %>%
  bind_cols(d2) %>%
  fill(everything(), .direction = "down") %>%
  mutate(Data = as.numeric(Data)) %>%
  select(Group, `Emp ID` = Data, Name = Data.1, Dept = Data.2)

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE