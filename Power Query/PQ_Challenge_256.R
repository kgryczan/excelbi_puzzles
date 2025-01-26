library(tidyverse)
library(readxl)

path = "Power Query/PQ_Problem_256.xlsx"
input = read_excel(path, range = "A1:I4")
test  = read_excel(path, range = "A8:C17")

result = input %>%
  mutate(T2 = `Start Date Time` + minutes(Dur1),
         T3 = T2 + minutes(Dur2),
         T4 = T3 + minutes(Dur3),
         T5 = T4 + minutes(Dur4),
         T6 = T5 + minutes(Dur5),
         T7 = T6 + minutes(Dur6),
         T8 = T7 + minutes(Dur7)) %>%
  select(-c(starts_with("Dur"))) %>%
  rename(T1 = `Start Date Time`) %>%
  pivot_longer(cols = -State, names_to = "ID", values_to = "Time") %>%
  na.omit() %>%
  mutate(order = (as.numeric(str_extract(ID, "\\d")) + 1) %/% 2  ,
         ID = ifelse(as.numeric(str_extract(ID, "\\d")) %% 2 == 0, "To", "From")) %>%
  pivot_wider(names_from = ID, values_from = Time) %>%
  select(State, From, To)
         
all.equal(result, test)
#> [1] TRUE