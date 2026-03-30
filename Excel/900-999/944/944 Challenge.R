library(tidyverse)
library(readxl)
library(igraph)

path <- "900-999/944/944 ES EF Calculation.xlsx"
input <- read_excel(path, range = "A2:C22")
test <- read_excel(path, range = "E2:G22")

edges <- input %>%
  filter(Dependencies != "") %>%
  separate_rows(Dependencies, sep = ",\\s*") %>%
  transmute(from = Dependencies, to = Task)

g <- graph_from_data_frame(edges, vertices = input$Task, directed = TRUE)
ord <- topo_sort(g, mode = "out") %>% as_ids()
dur <- deframe(input %>% select(Task, Duration))

ES <- EF <- set_names(numeric(length(ord)), ord)

for (x in ord) {
  p <- neighbors(g, x, mode = "in") %>% as_ids()
  ES[x] <- if (length(p) == 0) 0 else max(EF[p])
  EF[x] <- ES[x] + dur[x]
}

result = tibble(Task = ord, ES = ES[ord], EF = EF[ord]) %>%
  arrange(Task)

(result == test) %>% all()
# [1] TRUE

igraph::plot.igraph(g, vertex.label = V(g)$name)
