library(tidyverse)
library(readxl)

input = read_excel("Power Query/PQ_Challenge_167.xlsx", range = "A1:D14")
test  = read_excel("Power Query/PQ_Challenge_167.xlsx", range = "G1:K16")

result = input %>%
  mutate(`Camp No` = parse_number(`Camp No`),
         group = cumsum(!is.na(`Camp No`)),
         group_name = ifelse(`Camp No` == group, Vaccine, NA_character_)) %>%
  fill(group_name) %>%
  filter(is.na(`Camp No`)) %>%
  select(Vaccine = group_name,
         Name = Vaccine, 
         `Notification Date` = `Notification Date`,
         `Administration Date` = `Administration Date`) %>%
  pivot_wider(names_from = Name, values_from = c(`Notification Date`, `Administration Date`)) %>%
  pivot_longer(cols = -Vaccine, names_to = "Name", values_to = "Date") %>%
  separate(Name, into = c("Event", "Name"), sep = "_", remove = TRUE) %>%
  pivot_wider(names_from = Event, values_from = Date) %>%
  arrange(desc(Vaccine), Name) %>%
  mutate(`Camp No` = row_number() %>% as.numeric(), .by = Vaccine) %>%
  relocate(`Camp No`, .before = Vaccine) %>%
  mutate(Notified = ifelse(is.na(`Notification Date`), "No", "Yes"),
         Administered = ifelse(is.na(`Administration Date`), ifelse(is.na(`Notification Date`),"NA", "No"), "Yes")) %>%
  select(-c(4,5))

identical(result, test)
# [1] TRUE
