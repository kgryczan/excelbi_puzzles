library(tidyverse)
library(readxl)

path = "Excel/645 Align WBS Data.xlsx"
input = read_excel(path, range = "A1:B30")
test  = read_excel(path, range = "E1:J30")

result = reduce(0:5, function(data, i) {
  col = as.character(i)
  data = data %>% 
    mutate(!!col := if_else(str_detect(WBS, paste0("WBS_", col)), WBS, NA_character_))
  
  data = if (i == 0) {
    data %>% fill(!!sym(col), .direction = "down")
  } else {
    data %>% group_by(!!sym(as.character(i - 1))) %>% 
      fill(!!sym(col), .direction = "down") %>% 
      ungroup()
  }
  data
}, .init = input) %>% 
  mutate(across(everything(), ~replace_na(.x, "XXX"))) %>% 
  select(-WBS, -ID)

all.equal(result, test, check.attributes = FALSE) # TRUE
