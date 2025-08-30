library(tidyverse)
library(readxl)

path = "Power Query/300-399/317/PQ_Challenge_317.xlsx"
input = read_excel(path, range = "A1:C12")
test  = read_excel(path, range = "E1:F13")

result = input %>% 
  fill(Country, State) %>%
  summarise(Cities = paste0(Cities, collapse = ", "), .by = c(Country, State)) %>%
  mutate(Country = ifelse(row_number() == 1, Country, ""), .by = Country) %>%
  pivot_longer(everything(), names_to = "Data1", values_to = "Data2") %>%
  filter(Data2 != "") 

all.equal(result, test)
# > [1] TRUE