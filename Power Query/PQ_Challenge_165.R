library(tidyverse)
library(readxl)
library(janitor)

input = read_excel("Power Query/PQ_Challenge_165.xlsx", range = "A1:C11")
test  = read_excel("Power Query/PQ_Challenge_165.xlsx", range = "F1:I15")

r1 = input %>%
  mutate(`Max Bonus` = Salary * 0.1,
         group = cumsum(!is.na(Dept)))

make_summary = function(df, gr) {
  data <- df %>%
    filter(group == gr) 
  
  summary <- data %>%
    mutate(Dept = "Total") %>%
    summarise(Dept = first(Dept),
              Emp = as.character(n()),
              Salary = sum(Salary),
              `Max Bonus` = sum(`Max Bonus`))
  result = bind_rows(data, summary)
  return(result)
}

groups = unique(r1$group)
r2 = map_dfr(groups, ~make_summary(r1, .x))

grand_total = r2 %>%
  filter(!is.na(group)) %>%
  summarise(Dept = "Grand Total",
            Emp = as.character(n()),
            Salary = sum(Salary),
            `Max Bonus` = sum(`Max Bonus`))

result = bind_rows(r2, grand_total) %>%
  select(-group)

identical(result, test)
# [1] TRUE
