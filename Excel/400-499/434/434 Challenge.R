library(tidyverse)
library(stringi)
library(readxl)

test = read_excel("Excel/434 Generate the Column Headers Matrix.xlsx", 
                  range = "A2:E21", col_names = FALSE) %>%
  as.matrix()

col_names = c(LETTERS, do.call(paste0, expand.grid(LETTERS, LETTERS)), 
              do.call(paste0, expand.grid(LETTERS, LETTERS, LETTERS))) %>%
  map_chr(~stri_reverse(.))
  
  
columns = data.frame(cols = col_names) %>%
  mutate(indices = 1:nrow(.)) 

index <- accumulate(1:99, ~ .x + .y, .init = 1)

result_df = columns %>%
  filter(indices %in% index) %>%
  pull(cols)

result = matrix(result_df, nrow = 20, ncol = 5, byrow = FALSE)

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE
