library(tidyverse)
library(readxl)

input = read_excel("Power Query/PQ_Challenge_155.xlsx", range = "A1:A10")
test  = read_excel("Power Query/PQ_Challenge_155.xlsx", range = "D1:D10")

extract = function(string) {
  subs = string %>% 
    str_extract_all("\\d{1,2}\\:\\d{2}") %>%
    unlist()

  subs = purrr::map_chr(subs, function(x) {
    ifelse(
      as.numeric(strsplit(x, ":")[[1]][1]) %in% 0:23 & as.numeric(strsplit(x, ":")[[1]][2]) %in% 0:59,
      x,
      NA_character_
    )
  }) %>%
    na.omit() %>%
    str_c(collapse = ", ")

  return(subs)
}

result = input %>% 
  mutate(extracted = map_chr(String, extract),
         extracted = ifelse(extracted == "", NA_character_, extracted))

identical(result$extracted, test$`Expected Answer`)
# [1] TRUE