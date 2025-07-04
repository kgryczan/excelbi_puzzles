library(tidyverse)
library(readxl)

path = "Excel/700-799/753/753 Pivot on Years.xlsx"
input = read_excel(path, range = "A2:A6")
test  = read_excel(path, range = "C2:H6")

result = input %>%
  separate_wider_delim(col = "Data",
                       delim = " : ", 
                       names = c("Name", "Years")) %>%
  separate_longer_delim(col = "Years",
                       delim = ", ") %>%
  separate_wider_delim(col = "Years",
                       delim = "-",
                       names = c("Year", "Value"),
                       too_few = "align_end") %>%
  fill(Year) %>%
  mutate(Value = as.numeric(Value)) %>%
  pivot_wider(names_from = Year, 
              values_from = Value, 
              values_fn = sum) %>%
  select(Name, `2021`, `2022`, `2023`, `2024`, `2025`) 

all.equal(result, test)
# > [1] TRUE