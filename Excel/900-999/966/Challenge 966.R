library(tidyverse)
library(readxl)
library(igraph)

path <- "900-999/966/966 Least Cost Path.xlsx"
input <- read_excel(path, range = "A2:C17")
test <- read_excel(path, range = "E2:F3")

edges <-
  input %>%
  separate_rows(ValidDestinations, sep = ",") %>%
  drop_na(ValidDestinations) %>%
  transmute(from = NodeID, to = ValidDestinations)
g <- graph_from_data_frame(edges, directed = TRUE)
V(g)$cost <- input$EntryCost[match(V(g)$name, input$NodeID)]
paths <- all_simple_paths(
  g,
  from = V(g)[str_detect(name, "^A")],
  to = V(g)[str_detect(name, "^E")]
)
res <-
  map_dfr(paths, \(p) {
    tibble(
      Path = paste(V(g)$name[p], collapse = ","),
      `Total Cost` = sum(V(g)$cost[p])
    )
  }) %>%
  slice_min(`Total Cost`, n = 1)
all.equal(res, test)
# [1] TRUE
