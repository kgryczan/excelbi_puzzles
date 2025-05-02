  library(tidyverse)
  library(readxl)
  
  path = "Power Query/PQ_Challenge_236.xlsx"
  input = read_excel(path, range = "A1:F5")
  test  = read_excel(path, range = "I1:J16")  %>%
    mutate(
      Data2 = case_when(
        Data1 == "Date" & !is.na(as.numeric(Data2)) ~ as.character(as.Date(as.numeric(Data2), origin = "1899-12-30")),
        TRUE ~ as.character(Data2)
    )
  )
  
  result = input %>%
    mutate(across(everything(), as.character)) %>%
    mutate(nr = c(1,1,2,2)) %>%
    pivot_longer(names_to = "Data1", values_to = "Data2", cols = -nr) %>%
    na.omit() %>% 
    distinct() %>%
    select(-nr) 

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE
