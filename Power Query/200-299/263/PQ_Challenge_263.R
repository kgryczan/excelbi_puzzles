library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_263.xlsx"
input1 = read_excel(path, range = "A1:B132")
input2 = read_excel(path, range = "D1:F7")
test  = read_excel(path, range = "D12:E16")

result = input2 %>%
  pivot_longer(everything(), names_to = "Attitude", values_to = "Response", values_drop_na = TRUE) %>%
  left_join(input1, by = c("Response" = "Responses")) %>%
  summarise(count = n(), .by = c(Store, Attitude)) %>%
  mutate(Rank = dense_rank(desc(count)), .by = Attitude) %>%
  filter(Attitude == "Green" ) %>%
  select(Store, Rank)


