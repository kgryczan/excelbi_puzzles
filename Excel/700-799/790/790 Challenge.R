library(tidyverse)
library(readxl)

path = "Excel/700-799/790/790 Pivot.xlsx"
input = read_excel(path, range = "A2:A12")
test  = read_excel(path, range = "C2:F6")

result = input %>% 
   mutate(Name = ifelse(str_detect(Data, "Name"), Data, NA) %>% 
                 str_remove("Name: ")) %>%
  fill(Name) %>%
  separate_wider_delim(Data, delim = ": ", names = c("Key", "Value")) %>%
  filter(Name != Value) %>%
  pivot_wider(names_from = Key, values_from = Value) %>%
  separate_longer_delim(Department, delim = " | ") %>%
  mutate(Age = as.integer(Age),
         Salary = parse_number(Salary))

all.equal(result, test)
# > [1] TRUE