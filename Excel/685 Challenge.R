library(tidyverse)
library(readxl)
library(lubridate)
library(igraph)

path = "Excel/685 Overlapping Tasks.xlsx"
input = read_excel(path, range = "A1:C8")
test  = read_excel(path, range = "E1:E4")

input$interval = interval(input$`Planned Start Date`, input$`Planned End Date`)

tasks = expand.grid(input$Task, input$Task, stringsAsFactors = FALSE) %>%
  left_join(input, by = c("Var1" = "Task")) %>%
  left_join(input, by = c("Var2" = "Task")) %>%
  select(Task1 = Var1, Task2 = Var2, interval1 = interval.x, interval2 = interval.y) %>%
  filter(Task1 < Task2) %>%
  mutate(overlap = int_overlaps(interval1, interval2)) %>%
  filter(overlap) %>%
  select(Task1, Task2)

g = graph_from_data_frame(tasks, directed = FALSE)
subgraphs = decompose.graph(g) %>%
  map(~V(.)$name) %>%
  map_chr(~paste(., collapse = ", ")) %>%
  data.frame(ans = .) %>%
  arrange(ans)

all.equal(subgraphs$ans, test$`Anwer Expected`, check.attributes = FALSE)
#> [1] TRUE