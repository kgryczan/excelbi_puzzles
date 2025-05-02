library(tidyverse)
library(readxl)

input = read_excel("Excel/388 Kamasutra Cipher_2.xlsx", range = "A1:A10")

generate_code = function() {
  shuffled_alph = sample(letters)
  sh_p1 = shuffled_alph[1:(length(shuffled_alph)/2)] 
  sh_p2 = shuffled_alph[(length(shuffled_alph)/2 + 1):length(shuffled_alph)]
  sh_p1 = setNames(sh_p1, sh_p2)
  sh_p2 = setNames(sh_p2, sh_p1)
  code = c(sh_p1, sh_p2)
  
  shuffled_digits = sample(0:9)
  sh_d1 = shuffled_digits[1:(length(shuffled_digits)/2)]
  sh_d2 = shuffled_digits[(length(shuffled_digits)/2 + 1):length(shuffled_digits)]
  sh_d1 = setNames(sh_d1, sh_d2)
  sh_d2 = setNames(sh_d2, sh_d1)
  code = c(code, sh_d1, sh_d2)
  return(code)
}

code = function(string){
  code = generate_code()
  string = tolower(string)
  words = str_split(string, " ")[[1]]
  chars = map(words, str_split, "") %>%
    map(unlist)
  coded_chars = map(chars, function(x) code[x])
  coded_words = map(coded_chars, paste, collapse = "") 
  coded_string = paste(coded_words, collapse = " ")
  return(coded_string)
}

result = input %>%
  mutate(coded = map_chr(`Plain Text`, code))
result
