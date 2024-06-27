library(tidyverse)
library(readxl)

path = "Excel/487 Maximum Frequency Characters.xlsx"
input = read_xlsx(path, range = "A2:A11")
test  = read_xlsx(path, range = "B2:C11")

find_most_freq_char = function(input) {
  result = input %>% 
    strsplit("") %>% 
    unlist() %>% 
    table()
  df = data.frame(
    Characters = names(result),
    Frequency = as.numeric(result)) %>% 
    filter(Frequency == max(Frequency)) %>%
    summarise(Characters = paste(sort(Characters), collapse = ", "), .by = Frequency) %>%
    select(Characters, Frequency)
  return(df)
}

result = input$Strings %>%
  map(find_most_freq_char) %>%
  bind_rows()

# Validation on eye, all correct. In three cases there is different sorting than
#  in provided example but with the same characters.