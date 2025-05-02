library(tidyverse)
library(readxl)

path = "Excel/027 Skills Checker.xlsx"
input1 = read_excel(path, range = "A1:C9")
input2 = read_excel(path, range = "E1:F7") 
test  = read_excel(path, range = "H1:H4")

app_primary = as.character(input2$`Primary Skills`) %>% na.omit()
app_secondary = as.character(input2$`Secondary Skills`) %>% na.omit()

result = input1 %>%
  mutate(primary = str_split(`Primary Skills`, ", "), 
         secondary = str_split(`Secondary Skills`, ", ")) %>%
  mutate(primary_count = map_int(primary, ~sum(.x %in% app_primary)),
         secondary_count = map_int(secondary, ~sum(.x %in% app_secondary))) %>%
  filter(primary_count >= 2 & secondary_count >= 3) %>%
  select(Candidate)

identical(result$Candidate, test$`Expected Answer`)
# [1] TRUE