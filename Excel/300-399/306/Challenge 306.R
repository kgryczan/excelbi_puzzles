library(tidyverse)
library(readxl)
library(gmp)
library(data.table)

input = read_excel("Excel/300-399/306/306 Semi Prime Numbers.xlsx", range = "A1:A10")
test = read_excel("Excel/300-399/306/306 Semi Prime Numbers.xlsx", range = "C1:C5")

is_semiprime = function(n){
  factors <- n %>%
    as.character() %>%
    as.bigz() %>% 
    factorize() %>% 
    as.vector()
  check = ifelse(length(factors) == 2, TRUE, FALSE)
  
  return(check)
}


result = input$Numbers %>%
  keep(~ is_semiprime(.))

identical(result, test$`Expected Answers`)