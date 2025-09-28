library(tidyverse)
library(readxl)

path = "Power Query/300-399/326/PQ_Challenge_326.xlsx"
input1 = read_excel(path, range = "A2:B8")
input2 = read_excel(path, range = "A11:B21")
test  = read_excel(path, range = "D2:I8")

delims = input2 %>%
  group_by(ID) %>%
  summarise(
    pattern = str_c("(?i)", str_c(Splitter, collapse = "|"))
  )

result = input1 %>%
  left_join(delims, by = "ID") %>%
  mutate(
    split_col = map2(Data, pattern, ~str_split(.x, .y, simplify = TRUE)[1,]),
    Data = map(split_col, ~.x[.x != ""])
  ) %>%
  unnest_wider(Data, names_sep = "") %>%
  select(ID, starts_with("Data")) 

all.equal(result, test)
# [1] TRUE
