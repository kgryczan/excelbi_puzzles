library(tidyverse)
library(readxl)

path = "Excel/800-899/827/827 Lorem Ipsum.xlsx"
input = read_excel(path, range = "A1:B2")
test  = read_excel(path, range = "C1:C2") %>% pull()

words = unlist(str_split(input$Text[1] %>% str_remove_all("[[:punct:]]"), " "))
chars = unlist(str_split(input$Alphabets[1], ""))

out = c()

for (a in chars) {
  i = which(str_detect(words, a))[1]
  if (length(i)) {
    out = c(out, words[i])
    words = words[-(1:i)]
  }
}
result = str_c(out, collapse = " ")
identical(result, test)
# [1] TRUE