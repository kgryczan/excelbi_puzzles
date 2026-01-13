library(tidyverse)
library(readxl)

path <- "Excel/800-899/890/890 Lowest Value.xlsx"
input <- read_excel(path, range = "B3:D20")
test <- read_excel(path, range = "G3:I7")

groups <- unique(input$Area)
results <- map_dfr(groups, function(group) {
  group_data <- input %>% filter(Area == group)
  lowest_row <- group_data %>% filter(Value == min(Value)) %>% slice(1)
  input <<- input %>% filter(Company != lowest_row$Company)
  lowest_row
})

all.equal(results, test, check.attributes = FALSE)
# [1] TRUE
