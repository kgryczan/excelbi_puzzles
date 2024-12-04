library(tidyverse)
library(readxl)

path = "Excel/179 Remove if consecutive.xlsx"
input = read_excel(path, range = "A1:A6")
test  = read_excel(path, range = "B1:B6")

remove_cons = function(string) {
  chars = str_split(tolower(string), "")[[1]]
  chars[chars != lag(chars, default = "")] %>% paste0(collapse = "")
}

remove_cons("Eexxxxxccceeell")

result = input %>%
  mutate(`Answer Expected` = map_chr(String, remove_cons))

all.equal(result$`Answer Expected`, test$`Answer Expected`)
