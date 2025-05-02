library(tidyverse)
library(readxl)

input = read_excel("Power Query/PQ_Challenge_166.xlsx", range = "A1:C14")
test  = read_excel("Power Query/PQ_Challenge_166.xlsx", range = "E1:H5")

result = input %>%
  fill(`Tracking No`, .direction = "down") %>%
  mutate(group = cumsum(str_starts(`Tracking No`, pattern = "[A-Z]"))) %>%
  group_by(group) %>%
  summarise(`Tracking No` = paste0(unique(`Tracking No`), collapse = ", "),
            `Item Count` = n_distinct(`Items`, na.rm = TRUE) %>% as.numeric(),
            `Total Amount` = sum(`Amount`, na.rm = TRUE)) %>%
  select(-group) %>%
  separate(`Tracking No`, into = c("Company", "Trackng No"), sep = ", ") %>%
  mutate(`Trackng No` = as.numeric(`Trackng No`)) %>%
  ungroup() %>%
  arrange(Company)

test == result
