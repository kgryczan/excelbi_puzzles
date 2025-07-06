library(tidyverse)
library(readxl)

path = "Power Query/300-399/302/PQ_Challenge_302.xlsx"
input = read_excel(path, range = "A1:C12")
test  = read_excel(path, range = "E1:F13")

result = input %>%
  fill(Country, State) %>%
  summarise(Cities = paste0(Cities, collapse = ", "), .by = c("Country", "State")) %>%
  pivot_longer(everything()) %>%
  mutate(no = row_number(), .by = c("name", "value")) %>%
  filter(no == 1) %>%
  select(Data1 = name, Data2 = value) 

all.equal(result, test)
# > [1] TRUE