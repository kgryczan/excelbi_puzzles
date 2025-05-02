library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_207.xlsx"
input = read_excel(path, range = "A2:H13")
test  = read_excel(path, range = "K2:P9")

r1 = input %>%
  pivot_longer(names_to = "Day of Week",  values_to = "Value", cols = -c(1)) 

r1$`Day of Week` = factor(r1$`Day of Week`, 
                          levels = c("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"), 
                          ordered = TRUE)

r2 = r1 %>%
  filter(Value == "Y") %>%
  mutate(nr = row_number(), .by = `Day of Week`) %>%
  select(-Value) %>%
  pivot_wider(names_from = nr, values_from = Name, names_glue = "Name{nr}") %>%
  complete(`Day of Week`) %>%
  mutate(`Day of Week` = as.character(`Day of Week`))

all.equal(r2, test, check.attributes = FALSE)
#> [1] TRUE