library(tidyverse)
library(readxl)

path = "Excel/205 Net Take Home Salary.xlsx"
input1 = read_excel(path, range = "A1:B10")
input2  = read_excel(path, range = "D1:F5") %>%
  mutate(To = ifelse(To == "No Limit", Inf, as.numeric(To)))
test = read_excel(path, range = "H1:I3")

result = input1 %>%
  fuzzyjoin::fuzzy_left_join(input2, by = c("Salary" = "From", "Salary" = "To"), 
                              match_fun = list(`>=`, `<=`)) %>%
  mutate(Salary_net = Salary * (1 - Deduction)) %>%
  slice_max(Salary_net, n = 1) %>%
  select(Names, Salary) 

all.equal(result, test) # TRUE