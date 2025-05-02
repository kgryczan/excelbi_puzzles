library(tidyverse)
library(readxl)

path = "Excel/155 Polybius Cipher Encrypt.xlsx"
input = read_excel(path, range = "A2:G8")
input1 = read_excel(path, range = "I1:I7")
test  = read_excel(path, range = "J1:J7")

input2 = input %>%
  pivot_longer(-c(1), names_to = "key", values_to = "value") %>%
  unite("key", c(`...1`, key), sep = "")

encode_message = function(message, code = input2) {
  message = str_to_upper(message)
  message = str_split(message, "") %>% unlist() %>% as_tibble() %>% rename(value = value) %>%
  left_join(code, by = "value") %>%
  mutate(key = ifelse(is.na(key), value, key)) %>%
  pull(key) %>%
  str_c(collapse = "")
  
  return(message)
}

result = input1 %>%
  mutate(`Encrypted Text` = map_chr(Text, encode_message))

all.equal(result$`Encrypted Text`, test$`Encrypted Text`)
#> [1] TRUE