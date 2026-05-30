library(tidyverse)
library(readxl)
library(igraph)

path <- "300-399/395/PQ_Challenge_395.xlsx"
input <- read_excel(path, range = "A1:B21")
test <- read_excel(path, range = "D1:E21")

org_chart <- graph_from_data_frame(input, directed = TRUE)
levels <- map_int(
  setdiff(V(org_chart)$name, "CEO"),
  ~ {
    length(shortest_paths(org_chart, from = .x, to = "CEO")$vpath[[1]]) - 1L
  }
)
df <- data.frame(Employee = input$Employee, Level = levels)
all.equal(df, test, check.attributes = FALSE)
# [1] TRUE
