library(tidyverse)
library(readxl)

path <- "Power Query/300-399/340/PQ_Challenge_840.xlsx"
input <- read_excel(path, range = "A1:B16")
test  <- read_excel(path, range = "D1:G6")

result <- input %>%
  summarise(Revenue = sum(Revenue), .by = Group)

grid = crossing(x = result$Group, y = result$Group) %>%
  filter(x != y) %>%
  left_join(result, by = c("x" = "Group")) %>%
  left_join(result, by = c("y" = "Group"), suffix = c(".x", ".y")) %>%
  mutate(diff = abs(Revenue.x - Revenue.y)) %>%
  filter(diff == min(diff), .by = x) %>%
  summarise(Revenue = first(Revenue.x),
            `Next Nearest Group` = paste0(y, collapse = ", "),
            `Next Nearest Group Revenue` = first(Revenue.y),
            .by = x) %>%
  rename(Group = x) 

all.equal(grid, test)
