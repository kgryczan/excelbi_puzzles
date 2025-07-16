  library(tidyverse)
library(readxl)

input = read_excel("Pronic Numbers.xlsx") %>% select(Numbers)

is_pronic = function(n) {
  l_number = floor(sqrt(n))
  result = n == l_number * (l_number+1)
  return(result)
}

result = input %>%
  mutate(IsPronic = map(Numbers, is_pronic)) %>%
  filter(IsPronic == TRUE) %>%
  select(Numbers)