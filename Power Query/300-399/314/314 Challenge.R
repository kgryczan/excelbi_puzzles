library(tidyverse)
library(readxl)
library(igraph)

path = "Power Query/300-399/314/PQ_Challenge_314.xlsx"
input = read_excel(path, range = "A1:C12")
test  = read_excel(path, range = "F1:G12")

result = input %>%
  mutate(`Previous Step` = na_if(`Previous Step`, ""), across(c(Step, `Previous Step`), as.character)) %>%
  group_by(Process) %>%
  group_modify(~{
    prev = deframe(filter(.x, !is.na(`Previous Step`)) %>% select(Step, `Previous Step`))
    chain = function(s) {
      out = s
      while (!is.na(prev[s]) && !(prev[s] %in% out)) {
        s = prev[s]
        out = c(out, s)
      }
      paste(out, collapse = "-")
    }
    mutate(.x, `Steps Chain` = if_else(is.na(`Previous Step`), Step, map_chr(Step, chain)))
  }) %>%
  ungroup() %>%
  select(Process, `Steps Chain`)

all.equal(result, test, check.attributes = FALSE)
# > [1] TRUE