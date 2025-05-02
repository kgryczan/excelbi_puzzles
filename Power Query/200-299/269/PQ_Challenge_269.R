library(tidyverse)
library(readxl)
library(igraph)

path = "Power Query/PQ_Challenge_269.xlsx"
input = read_excel(path, range = "A1:B15")
test  = read_excel(path, range = "D1:D13") %>% arrange(Result)

g = graph_from_data_frame(input, directed = TRUE)
all_paths = all_simple_paths(g, from = "City1", to = V(g))
all_paths_df = map_df(all_paths, ~{
  path = .x
  path_str = paste(V(g)[path]$name, collapse = "-")
  data.frame(path = path_str)
}) %>%
  arrange(path)

all.equal(all_paths_df$path, test$Result) # TRUE
