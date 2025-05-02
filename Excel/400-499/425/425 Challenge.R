library(tidyverse)
library(readxl)

input = read_excel("Excel/425 Hex Color Blending.xlsx", range = "A1:B10")
test  = read_excel("Excel/425 Hex Color Blending.xlsx", range = "C1:C10")

result = input %>%
  mutate(Color1 = strsplit(as.character(input$Color1), ", ") %>%
           map(., ~as.numeric(.x)),
         Color2 = strsplit(as.character(input$Color2), ", ") %>%
           map(., ~as.numeric(.x))) %>%
  mutate(FinalColor = map2(Color1, Color2, ~ceiling((.x + .y) / 2))) %>%
  mutate(`Answer Expected` = map_chr(FinalColor, ~rgb(.x[1], .x[2], .x[3], maxColorValue = 255))) %>%
  select(-Color1, -Color2, -FinalColor)

identical(result, test)
#> [1] TRUE
