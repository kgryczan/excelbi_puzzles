library(tidyverse)
library(readxl)

path = "Excel/536 Populate Grid for Rows and Columns.xlsx"
input = read_excel(path, range = "A1:C10")
test = read_excel(path, range = "E2:J7")

# Tidyverse Approach
result = input %>%
  pivot_wider(names_from = Column, 
              values_from = Value, 
              values_fn = list(Value = function(x) paste(x, collapse = ", "))) %>%
  mutate(`5` = NA) %>%
  select(Row, `1`, `2`, `3`, `4`, `5`) %>%
  arrange(Row)

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE

--------------------------------------------------------------------------------
# Matrix Approach

M = matrix(NA_character_, nrow = 5, ncol = 5)
for (i in 1:nrow(input)) {
  M[input$Row[i], input$Column[i]] = ifelse(is.na(M[input$Row[i], input$Column[i]]), 
                                            as.character(input$Value[i]), 
                                            paste(M[input$Row[i], input$Column[i]], as.character(input$Value[i]), sep = ", "))
}

testM = test %>% as.matrix() %>%
  .[, -1] 

all.equal(M, testM, check.attributes = FALSE)
# [1] TRUE