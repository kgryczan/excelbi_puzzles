library(tidyverse)
library(readxl)
library(igraph)

path <- "1000-1099/1025/1025 Grouping.xlsx"
input <- read_excel(path, range = "A2:B22")
test <- read_excel(path, range = "D2:E9", col_types = "text")

codes <- input %>%
  transmute(node = row_number(), code = map_chr(Code, ~ paste(sort(str_split(.x, "")[[1]]), collapse = "")))

edges <- tidyr::crossing(from = codes$node, to = codes$node) %>%
  filter(from < to) %>%
  mutate(distance = map2_int(codes$code[from], codes$code[to], ~ as.integer(adist(.x, .y)))) %>%
  filter(distance <= 1)

graph <- graph_from_data_frame(
  edges %>% select(from, to),
  directed = FALSE,
  vertices = tibble(name = as.character(codes$node))
)

components <- tibble(
  node = codes$node,
  component = unname(components(graph)$membership),
  ID = as.character(input$ID)
) %>%
  group_by(component) %>%
  summarise(IDs = str_c(ID, collapse = ","), .groups = "drop")

result <- tibble(
  Group = paste0("G", seq_len(nrow(components))),
  IDs = components$IDs
)

all.equal(result, test)
# TRUE
