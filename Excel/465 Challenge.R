library(tidyverse)
library(readxl)

input = read_excel("Excel/465 Task Assignment.xlsx", range = "A1:E10")

task_candidates <- input  %>%
  select(Task_ID = `Task ID`, P1, P2, P3, P4) %>%
  pivot_longer(cols = P1:P4, names_to = "Person", values_to = "Candidate") %>%
  filter(!is.na(Candidate))

assignments <- tibble(Task_ID = integer(), Person = character())

assign_tasks <- function(candidates) {
  task_count <- tibble(Person = unique(candidates$Person), Count = 0)
  
  for (task in unique(candidates$Task_ID)) {
    possible_people <- candidates %>%
      filter(Task_ID == task) %>%
      arrange(task_count$Count[match(Person, task_count$Person)])
    
    chosen_person <- possible_people$Person[1]
    assignments <<- assignments %>% add_row(Task_ID = task, Person = chosen_person)
    task_count$Count[task_count$Person == chosen_person] <- task_count$Count[task_count$Person == chosen_person] + 1
  }
}

assign_tasks(task_candidates)

while (any(assignments %>% count(Person) %>% pull(n) > 3)) {
  assignments <- tibble(Task_ID = integer(), Person = character())
  assign_tasks(task_candidates)
}

assignments %>%
  arrange(Task_ID) %>%
  mutate(Person = case_when(
    Person == "P1" ~ "A",
    Person == "P2" ~ "B",
    Person == "P3" ~ "C",
    Person == "P4" ~ "D"
  ))
