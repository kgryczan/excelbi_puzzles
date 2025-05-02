library(tidyverse)
library(readxl)

path = "Excel/173 Vernam Cipher Encoder2.xlsx"
input = read_excel(path, range = "A1:B7")
test  = read_excel(path, range = "C1:C7")

dict = 0:25
names(dict) = letters

transcript = function(message, key) {
  message = map_chr(str_split(message, "")[[1]], ~ as.character(dict[.x]))
  key = map_chr(str_split(key, "")[[1]], ~ as.character(dict[.x]))
  
  transcript_raw = bitwXor(as.numeric(message), as.numeric(key)) %% 26
  transcript = map_chr(transcript_raw + 1, ~ names(dict)[as.integer(.x)])
  transcript = paste(transcript, collapse = "")
  
  return(transcript)
}

result = input %>%
  mutate(`Encryoted Message` = map2_chr(input$Message, input$Key, transcript))

all.equal(result$`Encryoted Message`, test$`Encryoted Message`)
# [1] TRUE