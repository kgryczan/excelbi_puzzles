library(tidyverse)
library(readxl)

path = "Excel/127 LStrip.xlsx"
input = read_excel(path, range = "A1:B11")
test  = read_excel(path, range = "C1:C11") 
test[is.na(test)] <- ""

lstrip <- function(input_string, lstrip_chars) {
  pattern <- paste0("^[" , lstrip_chars , "]+")
  result <- sub(pattern, "", input_string)
  return(result)
}

result <- input %>% 
  mutate(output = map2_chr(`Input String`, `LSTRIP Chars`, lstrip))

all.equal(result$output, test$Result, check.attributes = FALSE)
