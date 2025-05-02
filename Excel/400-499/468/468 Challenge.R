library(tidyverse)
library(readxl)

input = read_excel("Excel/467 Generate Min and Max Rows.xlsx", range = "A2:F20") 
test  = read_excel("Excel/467 Generate Min and Max Rows.xlsx", range = "I2:N10")

inst = read_excel("excel/467 Generate Min and Max Rows.xlsx", range = "H3:H10", col_names = "Inst")

r1 = inst %>%
  mutate(Inst = str_sub(Inst,1,6)) %>%
  separate(Inst, into = c("fun", "column"), sep = " ", remove = F) %>%
  mutate(fun = str_to_lower(fun))

r2 = r1 %>%
  mutate(index = ifelse(fun == "min",
                        map_int(column, ~which.min(input[[.x]])),
                        map_int(column, ~which.max(input[[.x]]))))


result = map_dfr(r2$index, ~input[.x,])
identical(result, test)
# [1] TRUE