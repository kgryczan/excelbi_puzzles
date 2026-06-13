library(tidyverse)
library(readxl)

path <- "300-399/399/PQ_Challenge_399.xlsx"
input1 <- read_excel(path, range = "A1:B11")
input2 <- read_excel(path, range = "D1:D9") %>% pull()
test <- read_excel(path, range = "F1:H41")

result <- input1 %>%
  mutate(
    exclusion = if_else(
      str_detect(Rule, "^All (Except|Other than)"),
      "Exclude",
      "Include"
    ),
    scope_list = Rule %>%
      str_remove("^All( Except| Other than)?\\s*") %>%
      str_split(",\\s*"),
    res = map2(Rule, scope_list, \(rule, scope) {
      if (rule == "All") {
        input2
      } else if (str_detect(rule, "^All (Except|Other than)")) {
        setdiff(input2, scope)
      } else {
        scope
      }
    })
  ) %>%
  select(Campaign, Category = res) %>%
  unnest(Category) %>%
  mutate(Campaign2 = Campaign)

all.equal(result, test)
# # [1] TRUE
