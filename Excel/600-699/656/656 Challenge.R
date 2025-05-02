library(tidyverse)
library(readxl)
library(igraph)

path = "Excel/656 Critical Path.xlsx"
input = read_excel(path, range = "A2:C12")
test  = read_excel(path, range = "D2:E3")

r1 = input %>%
  na.omit() %>%
  separate_rows(Predecessor, sep = ", ") %>%
  relocate(Predecessor, .before = Task)
g = graph_from_data_frame(r1, directed = TRUE)

longest_path = get_diameter(g, weights = E(g)$Duration)
lp = tibble(path = V(g)[longest_path]$name) %>%
  left_join(r1, by = c("path" = "Task")) %>%
  summarise(Duration = sum(Duration, na.rm = TRUE),
            `Critical Path` = paste(path, collapse = "-")) %>%
  mutate(`Critical Path` = paste0(`Critical Path`, "-End")) %>%
  select(2, 1)

all.equal(lp, test, check.attributes = FALSE)  
# [1] TRUE



