library(tidyverse)
library(readxl)

path = "Excel/618 Project Plan with Relationship.xlsx"
input = read_excel(path, range = "A2:D12")
test  = read_excel(path, range = "F2:G12")
        
input = input %>%
  mutate(
    Start = if_else(Task == "Start", `Plan Start`, as.Date(NA)),
    End = if_else(Task == "Start", `Plan Start` + days(Duration), as.Date(NA))
  )

predecessors = unique(input$Predecessor[!is.na(input$Predecessor)])

for (pred in predecessors) {
  input = input %>%
    mutate(
      Start = case_when(
        Predecessor == pred ~ input$End[input$Task == pred],
        !is.na(Start) ~ Start,
        TRUE ~ as.Date(NA)
      ),
      End = case_when(
        Predecessor == pred ~ Start + days(Duration),
        !is.na(End) ~ End,
        TRUE ~ as.Date(NA)
      )
    )
}
 
all.equal(test, input %>% select(Start, End), check.attributes = FALSE)
# [1] TRUE