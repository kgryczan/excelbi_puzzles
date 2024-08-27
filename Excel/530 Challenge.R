library(tidyverse)
library(readxl)

path = "Excel/530 Dates for Max Sales.xlsx"
input = read_excel(path, range = "A2:I11")
test  = read_excel(path, range = "J2:K11")

result <- input %>%
  pivot_longer(cols = -Name, names_to = c(".value", ".type"), names_pattern = "(Date|Amount)(.*)") %>%
  fill(Date, .direction = "down") %>%
  fill(Amount, .direction = "up") %>%
  select(-c(2)) %>%
  distinct() %>%
  group_by(Name) %>%
  filter(Amount == max(Amount)) %>%
  summarise(Date = paste(Date, collapse = ", "), Amount = first(Amount)) %>%
  ungroup()

print(result) # Eye-only validation

# A tibble: 9 × 3
#   Name     Date                               Amount
#   <chr>    <chr>                               <dbl>
# 1 Albert   2006-10-02                            716
# 2 Carl     2016-07-08, 2022-06-14                886
# 3 Danielle 2015-02-27                            970
# 4 Donald   2014-06-13                            898
# 5 Gregory  2016-10-15, 2016-05-31, 2002-11-10    913
# 6 Judith   2000-10-17, 2018-10-16                656
# 7 Michael  2022-08-02                            993
# 8 Rachel   2017-04-02                            690
# 9 Willie   2015-04-18                            684