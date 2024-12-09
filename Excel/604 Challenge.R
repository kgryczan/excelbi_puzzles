library(tidyverse)
library(readxl)
library(ggplot2)

path = "Excel/604 Transform Table.xlsx"
input = read_excel(path, range = "A1:E11", col_types = c("numeric", "text", "text", "date", "date"))

result = input %>%
  mutate(month = floor_date(Finish, "month")) %>%
  group_by(month, Stage) %>%
  mutate(rank = rank(Finish)) %>%
  select(Stage, `System No`, month, rank) %>%
  mutate(val = ifelse(Stage == "Pre-Comm", -1, 1)) %>%
  arrange(Stage, month, rank)

lims = as.POSIXct(c("2024-05-15", '2024-09-15'))    

top = ggplot(result , aes(x = month, y = val, label = `System No`, color = "white")) + 
  scale_x_datetime(date_breaks = "1 month", date_labels = "%b %Y", limits = lims) +
  geom_bar(stat = "identity", position = "stack", fill = "white") +
  geom_text(position = position_stack(vjust = 0.5), size = 3) + 
  geom_label(x = lims[1], y = 1.5, label = "Construction", angle = 90, color = "black") +
  geom_label(x = lims[1], y = -1.2, label = "Pre-Comm", angle = 90, color = "black") +
  geom_hline(yintercept = 0, size = 2, color = "black") + 
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        panel.border = element_blank(),
        axis.text.y = element_blank(),
        axis.title.y = element_blank(),
        axis.title.x = element_blank(),
        axis.ticks.y = element_blank(),
        legend.position = "none")

top

