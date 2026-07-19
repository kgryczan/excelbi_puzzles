library(tidyverse)
library(readxl)

path <- "400-499/410/PQ_Challenge_410.xlsx"
input <- read_excel(path, range = "A1:D21")
test <- read_excel(path, range = "F1:I21")

solve <- function(PersonID, PersonName, StepSize) {
  alive <- PersonID
  names <- setNames(PersonName, PersonID)
  index <- 1

  map_dfr(seq_along(alive), function(order) {
    index <<- ((index + StepSize - 2) %% length(alive)) + 1
    person_id <- alive[index]
    alive <<- alive[-index]
    tibble(
      EliminationOrder = order,
      PersonID = person_id,
      PersonName = unname(names[as.character(person_id)])
    )
  })
}

result <- input %>%
  group_by(Group) %>%
  group_modify(~ solve(.x$PersonID, .x$PersonName, .x$StepSize[[1]])) %>%
  ungroup()

all.equal(result, test)
# TRUE
