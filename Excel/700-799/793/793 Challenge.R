library(tidyverse)
library(readxl)

path = "Excel/700-799/793/793 Alphabet Shuffle.xlsx"
input = read_excel(path, range = "A1:B8")
test  = read_excel(path, range = "D1:D8")

gen = function(start, length) {
  start_idx = which(LETTERS == start)
  chars = LETTERS[((seq(start_idx, start_idx + length - 1) - 1) %% 26) + 1]
  
  shuffled = keep(replicate(10001, sample(chars), simplify = FALSE), 
                  ~ !any(map2_lgl(.x[-1], .x[-length(.x)], 
                                  ~ (utf8ToInt(.x) - utf8ToInt(.y)) %% 26 == 25)))
  if (length(shuffled) > 0) return(paste(shuffled[[1]], collapse = ", "))
}

result = input %>%
  mutate(Shuffled = map2_chr(Alphabet, Length, gen))
