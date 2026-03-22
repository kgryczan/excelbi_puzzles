library(dplyr)
library(readxl)
library(purrr)

path <- "300-399/376/PQ_Challenge_376.xlsx"
input <- read_excel(path, range = "A1:D21")
test <- read_excel(path, range = "F1:H21")

parent <- setNames(input$ParentCommitID, input$CommitID)

get_path <- function(id) {
  path <- id
  while (!is.na(parent[path[1]])) {
    path <- c(parent[path[1]], path)
  }
  paste(path, collapse = " > ")
}

result <- input |>
  select(CommitID, Author) |>
  mutate(FullPath = map_chr(CommitID, get_path))

identical(result, test)
# [1] TRUE
