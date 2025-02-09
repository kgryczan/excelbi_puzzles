library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_260.xlsx"
input = read_excel(path, range = "A1:C16")
test  = read_excel(path, range = "E1:N4") %>% mutate(across(everything(), as.character))

names_ = names(test)

df_sum <- input %>% 
  group_by(Group, Dept) %>% 
  summarize(Team = paste(Team, collapse = ", "), .groups = "drop") %>% 
  arrange(Team) %>% 
  mutate(rn = row_number(), .by = Group)

r1 <- df_sum %>% 
  pivot_wider(id_cols = rn, names_from = c(Group, Dept), values_from = Team, names_sep = "  ") %>% 
  left_join(df_sum %>% 
              select(-Team) %>% 
              pivot_wider(names_from = Group, values_from = Dept),
            by = "rn") %>% 
  select(-rn) %>% 
  rename_with(~ifelse(nchar(.) == 2, ., str_trim(substr(., 4, nchar(.))))) %>% 
  select(any_of(names_))

all.equal(r1, test, check.attributes = FALSE)
#> [1] TRUE
