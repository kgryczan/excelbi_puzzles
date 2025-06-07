library(tidyverse)
library(readxl)

input <- read_excel("Power Query/200-299/293/PQ_Challenge_293.xlsx", range = "A1:J6", col_names = FALSE)
test  <- read_excel("Power Query/200-299/293/PQ_Challenge_293.xlsx", range = "A10:J15")

clean <- input[-c(1,2), ] %>%
  setNames(ifelse(is.na(input[1,]), input[2,], paste0(input[1,], "-", input[2,]))) %>%
  type_convert()

total <- bind_rows(
  clean,
  clean %>%
    summarise(
      Country = "Total", Capital = "EU",
      across(starts_with("Q", ignore.case = TRUE), ~sum(as.numeric(.), na.rm = TRUE))
    )
) %>%
  select(Country, Capital, starts_with("Q1"), starts_with("Q2"), starts_with("Q3"), starts_with("Q4"))

all.equal(total, test)
