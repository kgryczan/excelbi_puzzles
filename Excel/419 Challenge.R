library(tidyverse)
library(readxl)

test = read_excel("Excel/419 Reverse Divisible & Not Palindromes.xlsx", range = "A1:A12")

bases = c("1089", "2178")

insert9 = function(num_char,  max_length = 8) {
   
  fp = str_sub(num_char, 1,2)
  sp = str_sub(num_char, 3,4)
  
  sequence_of_nines <- map_chr(0:max_length, ~strrep("9", .x))

  generated_numbers <- map_chr(sequence_of_nines, ~paste0(fp, .x, sp))
    
  return(generated_numbers)
}

i9_1 =  insert9(bases[1], 8)
i9_2 =  insert9(bases[2], 8) 

insert0 = function(num_char,  max_length = 8) {
  sequence_of_zeroes <- map_chr(0:max_length, ~strrep("0", .x))
  generated_numbers <- map_chr(sequence_of_zeroes, ~paste0(num_char, .x, num_char))
  return(generated_numbers)
}

i0_1 =  insert0(bases[1], 8)
i0_2 =  insert0(bases[2], 8) 
 

generated_numbers = c(i9_1, i9_2, i0_1, i0_2) %>%
  as.numeric() %>%
  sort() %>%
  head(11)

identical(generated_numbers, test$`Expected Answer`)
# [1] TRUE