library(tidyverse)
library(readxl)
library(igraph)

path <- "900-999/983/983 Connected Nodes Networks.xlsx"
input <- read_excel(path, range = "A1:B21")
test <- read_excel(path, range = "C1:C7")

g <- graph_from_data_frame(input, directed = FALSE)
components <- components(g)
networks <- data.frame(
  network_id = integer(),
  nodes = character(),
  stringsAsFactors = FALSE
)
for (i in 1:components$no) {
  nodes <- V(g)[components$membership == i]$name
  networks <- rbind(
    networks,
    data.frame(
      network_id = i,
      nodes = paste(sort(nodes), collapse = ", "),
      stringsAsFactors = FALSE
    )
  )
}
result = networks %>%
  mutate(no_of_nodes = str_count(nodes, ",") + 1) %>%
  arrange(desc(no_of_nodes), nodes) %>%
  select(`Answer Expected` = nodes)

all.equal(result$`Answer Expected`, test$`Answer Expected`)
# [1] TRUE
