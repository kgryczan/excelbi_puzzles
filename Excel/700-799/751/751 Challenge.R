library(tidyverse)
library(readxl)
library(igraph)

path = "Excel/700-799/751/751 Levels of Managers.xlsx"
input = read_excel(path, range = "A2:B11")
test  = read_excel(path, range = "D2:H11")

g = graph_from_data_frame(input %>% filter(!is.na(Manager)))

hierarchy <- tibble(Employee = V(g)$name) %>%
  mutate(
    Managers = map(Employee, ~
                     names(subcomponent(g, .x, mode = "out")) %>%
                     setdiff(.x)
    )
  )

result = hierarchy %>%
  unnest_wider(Managers, names_sep = "_") %>%
  arrange(Employee)
colnames(result) <- colnames(test)

all.equal(result, test, check.attributes = FALSE)
# > [1] TRUE