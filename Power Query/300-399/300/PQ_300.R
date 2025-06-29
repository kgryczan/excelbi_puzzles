library(tidyverse)
library(readxl)

path = "Power Query/300-399/300/PQ_Challenge_300.xlsx"
input = read_excel(path, range = "A1:F12", col_names = FALSE)
test  = read_excel(path, range = "H1:L21")

result = input %>%
  mutate(Factory = ifelse(str_detect( `...1`, "Factory"), str_sub(`...1`, -1, -1), NA)) %>%
  fill(Factory, `...1`) %>%
  filter(str_detect(`...1`, "Factory", negate = T)) %>%
  rename(Project = `...1`, 
         Type = `...2`, 
         Q1 = `...3`, 
         Q2 = `...4`, 
         Q3 = `...5`, 
         Q4 = `...6`,
         Factory = Factory) %>%
  pivot_longer(cols = c(Q1, Q2, Q3, Q4), 
               names_to = "Quarter", 
               values_to = "Value") %>%
  mutate(Value = as.numeric(Value)) %>%
  pivot_wider(names_from = Type, values_from = Value) %>%
  select(Factory, Quarter, Project, Budget, Actual) 

all.equal(result, test)
# > [1] TRUE