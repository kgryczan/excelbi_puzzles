library(tidyverse)
library(readxl)

path = "Excel/162 Vernam Cipher Encoder.xlsx"
input = read_excel(path, range = "A1:B7")
test  = read_excel(path, range = "C1:C7")

dict = 0:25
names(dict) = letters

transcript = function(message, key) {
  message = map_chr(str_split(message, "")[[1]], ~ as.character(dict[.x]))
  key = map_chr(str_split(key, "")[[1]], ~ as.character(dict[.x]))
  
  transcript_raw = (as.numeric(message) + as.numeric(key)) %% 26
  transcript = map_chr(transcript_raw + 1, ~ names(dict)[as.integer(.x)])
  transcript = paste(transcript, collapse = "")
  
  return(transcript)
}

result = input %>%
  mutate(result = map2_chr(Message, Key, transcript))

all.equal(result$result, test$`Encryoted Message`)
#> [1] TRUE