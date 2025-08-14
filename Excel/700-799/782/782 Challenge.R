library(tidyverse)
library(readxl)

path = "Excel/700-799/782/782 Align.xlsx"
input = read_excel(path, range = "A2:C12")
test  = read_excel(path, range = "E2:F12")

result = c(input$Bird1, input$Bird2, input$Bird3) %>% 
  data.frame(Col = .) %>%
  na.omit() %>% 
  filter(Col != "Quantity") %>%
  mutate(type = ifelse(str_detect(Col, "\\d+"), 'num', 'text')) %>%
  mutate(number = row_number(), .by = type) %>%
  pivot_wider(names_from = type, values_from = Col) %>%
  mutate(num = as.numeric(num)) %>%
  select(Birds = text, Quantity = num)

all.equal(result, test, check.attributes = FALSE)
# > [1] TRUE