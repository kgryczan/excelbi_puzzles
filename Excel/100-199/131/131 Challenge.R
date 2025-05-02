library(tidyverse)
library(readxl)

path = "Excel/131 Masked Strings.xlsx"
input = read_excel(path, range = "A1:B10")
test  = read_excel(path, range = "C1:C10")

result = input %>%
  mutate(
    `Expected Answer` = map2_chr(`Masked String`, Chars, 
                           ~ {
                             asterisk_positions <- str_locate_all(.x, "\\*")[[1]][,1]
                             main_string_split <- str_split(.x, "")[[1]]
                             main_string_split[asterisk_positions] <- str_split(.y, "")[[1]]
                             str_c(main_string_split, collapse = "")
                           }
    )
  )

all.equal(result$`Expected Answer`, test$`Expected Answer`)
#> [1] TRUE