library(tidyverse)
library(readxl)

input = read_excel("Power Query/PQ_Challenge_171.xlsx", range = "A1:F7")
test  = read_excel("Power Query/PQ_Challenge_171.xlsx", range = "H1:I15")

result = Map(function(c1, c4, c2, c5, c3, c6) list(c(c1, c4), c(c2, c5), c(c3, c6)), 
                    input$Col1, input$Col4, input$Col2, input$Col5, input$Col3, input$Col6) %>%
  unlist(recursive = F) %>%
  Map(function(x) list(x[1], x[2]), .) %>%
  tibble(Col = .) %>%
  unnest_wider(Col, names_sep = "") %>%
  filter(!(is.na(Col1) & is.na(Col2)))

identical(result, test)
#> [1] TRUE


# second solution - with purrr::pmap

r1 = input %>%
  transmute(
    Col = pmap(
      list(Col1, Col4, Col2, Col5, Col3, Col6),
      ~list(c(..1, ..2), c(..3, ..4), c(..5, ..6))
    )
  ) %>%
  unnest(cols = Col) %>%
  unnest_wider(Col, names_sep = "") %>%
  filter(!(is.na(Col1) & is.na(Col2)))

identical(r1, test)
#> [1] TRUE
