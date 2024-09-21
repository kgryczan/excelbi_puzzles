library(tidyverse)
library(readxl)

path = "Excel/094 Middle Words Extract.xlsx"
input = read_excel(path, range = "A1:A8")
test  = read_excel(path, range = "B1:B8") %>% replace_na(list(Answer = ""))

get_middle_word = function(text) {
  words = strsplit(text, " ")[[1]]
  n = length(words)
  middle_position = floor((n+1)/2)
  if (n %in% c(1,2)) {
    return("")
  }
  else if (n %% 2 == 0) {
    return(paste(words[middle_position:(middle_position+1)], collapse = " "))
  }
  else {
    return(words[middle_position])
  }
}

result = input %>%
  mutate(Answer = map(Data, get_middle_word))

all.equal(result$Answer, test$Answer, check.attributes = FALSE)
#> [1] TRUE