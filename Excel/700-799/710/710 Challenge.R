library(tidyverse)
library(readxl)

path = "Excel/700-799/710/710 Combination.xlsx"
input = read_excel(path, range = "A1:B4")
input2 = read_excel(path, range = "D1:D2") %>% pull()
test = read_excel(path, range = "F1:F4")

result = expand_grid(
  Bread = 1:(input2 / input$Price[input$Item == "Bread"]),
  Snak = 1:(input2 / input$Price[input$Item == "Snak"]),
  Drink = 1:(input2 / input$Price[input$Item == "Drink"])
) %>%
  filter(
    input$Price[input$Item == "Bread"] *
      Bread +
      input$Price[input$Item == "Snak"] * Snak +
      input$Price[input$Item == "Drink"] * Drink ==
      input2
  ) %>%
  mutate(
    Result = paste0("Bread ", Bread, ", Snak ", Snak, ", Drink ", Drink)
  ) %>%
  select(Result)

all.equal(result, test)
#> [1] TRUE
