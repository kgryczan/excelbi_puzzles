library(tidyverse)
library(readxl)

input = read_excel("Call Duration.xlsx", range = "A1:C14")
test = read_excel("Call Duration.xlsx", range = "E2:G4")

result = input %>%
  rowwise() %>%
  mutate(vec = list(sort(c(Person1, Person2)))) %>%
  group_by(vec) %>%
  summarise(Duration = sum(Duration)) %>%
  ungroup() %>%
  drop_na() %>%
  mutate(Max = max(Duration),
         Person1 = map_chr(vec, ~.x[1]),
         Person2 = map_chr(vec, ~.x[2])) %>%
  filter(Duration == Max) %>%
  select(Person1, Person2, Duration) %>%
  as_tibble()

identical(result, test)