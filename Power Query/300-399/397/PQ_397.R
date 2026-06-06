library(tidyverse)
library(readxl)

path <- "300-399/397/PQ_Challenge_397.xlsx"
input <- read_excel(path, range = "A1:C30") %>% na.omit()
test <- read_excel(path, range = "E1:F3")

final_map <- unique(input$Month) %>%
  reduce(
    function(o, m) {
      x <- filter(input, Month == m)
      o[o == o[pull(slice_min(x, Revenue, n = 1), Territory)]] <- o[pull(
        slice_max(x, Revenue, n = 1),
        Territory
      )]
      o
    },
    .init = set_names(unique(input$Territory), unique(input$Territory))
  )

result <- tibble(Territory = names(final_map), Owner = unname(final_map)) %>%
  summarise(Territories = str_c(Territory, collapse = ", "), .by = Owner)

all.equal(result, test)
## [1] TRUE
