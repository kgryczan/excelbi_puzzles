library(tidyverse)
library(readxl)

path = "Excel/684 Align Name and Data.xlsx"
input = read_excel(path, range = "A2:A14")
test  = read_excel(path, range = "C2:D6") %>% 
  replace_na(list(Amounts = " "))                 


result = input %>% 
  mutate(Name = ifelse(str_detect(Data, "\\d"), NA, Data)) %>%
  fill(Name) %>%
  mutate(Data = ifelse(Data == "Robert", " ", Data)) %>%
  filter(Data != Name) %>%
  summarize(Amounts  = paste0(Data, collapse = ", "), .by = Name)

all.equal(result, test)
#> [1] TRUE
