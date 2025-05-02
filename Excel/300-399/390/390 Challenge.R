library(tidyverse)
library(readxl)

input = read_excel("Excel/390 Digit Equal to Sum of Digits.xlsx", range = "A1:A6")
test  = read_excel("Excel/390 Digit Equal to Sum of Digits.xlsx", range = "A1:D6")

compute = function(number) {
  df =  expand.grid(rep(list(0:number), number)) %>%
    mutate(sum = rowSums(.)) %>%
    filter(sum == number, Var1 != 0) %>%
    select(-sum) %>%
    unite("NO", everything(), sep = "", remove = TRUE)
  
  summary = df %>%
    summarise(Min = min(NO) %>% as.numeric(),
              Max = max(NO) %>% as.numeric(),
              Count = n() %>% as.numeric()) 
  
  return(summary)
}

result = input %>%
  mutate(summary = map_df(Digits, compute)) %>%
  unnest(summary)

identical(result, test)
# [1] TRUE

# Second approach

res = input %>%
  mutate(inputs = Digits - 1,
        Min = 10^(inputs) + inputs,
         Max = (Digits)  * 10^(inputs),
         Count = choose(2 * (inputs), inputs)) %>%
  unnest() %>% 
  select(-inputs)

identical(res, test)
# [1] TRUE
