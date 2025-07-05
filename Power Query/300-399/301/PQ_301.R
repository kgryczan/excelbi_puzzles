library(tidyverse)
library(readxl)

path = "Power Query/300-399/301/PQ_Challenge_301.xlsx"
input = read_excel(path, range = "A1:E9")
test  = read_excel(path, range = "G1:I21")

result = input %>%
  mutate(type = ifelse(str_detect(Col1, "\\d"), "Value", "Text"), 
         cumsum = cumsum(type == "Text")) %>%
  pivot_longer(cols = -c(type, cumsum), 
             names_to = "Column", 
             values_to = "Value") %>%
  pivot_wider(names_from = type, 
            values_from = Value) %>%
  select(-Column) %>%
  na.omit() %>%
  unite( "Combined", Text, Value, sep = "-", remove = TRUE) %>%
  nest_by(cumsum) %>%
  mutate(data1 = map(data, ~ expand.grid(.x, .x) %>% as_tibble() %>%
                       separate(Var1, into = c("Text1", "Value1"), sep = "-", remove = TRUE, convert = TRUE) %>%
                       separate(Var2, into = c("Text2", "Value2"), sep = "-", remove = TRUE, convert = TRUE) %>%
                       filter(Text1 < Text2))) %>%
  ungroup() %>%
  unnest(data1) %>%
  select(Letter1 = Text1, Letter2 = Text2, Value1, Value2) %>%
  mutate(Total = Value1 + Value2) %>%
  select(Letter1, Letter2, Total) %>%
  arrange(Letter1, Letter2)

all.equal(result, test)         
# > TRUE