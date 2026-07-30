library(tidyverse)
library(readxl)

path <- "1000-1099/1032/1032 Marks Calculation.xlsx"
marks <- read_excel(path, range = "A2:D30")
expected <- read_excel(path, range = "F2:G7")

score <- function(d) {
  if (nrow(d) < 5) {
    return(0)
  }
  core <- d %>% filter(Subject_Type == "Core") %>% pull(Marks)
  electives <- d %>%
    filter(Subject_Type == "Elective") %>%
    arrange(desc(Marks)) %>%
    slice_head(n = 5 - length(core)) %>%
    pull(Marks)
  failing <- sort(core[core < 50])
  n <- min(length(failing), length(electives))
  electives[seq_len(n)] <- electives[seq_len(n)] * .9
  round(sum(core) + sum(electives))
}

result <- marks %>%
  group_by(Student_ID) %>%
  summarise(Final_Score = score(pick(everything())), .groups = "drop")

print(all.equal(result, expected))
