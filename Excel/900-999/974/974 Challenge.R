library(tidyverse)
library(readxl)

path <- "900-999/974/974 RFM Score.xlsx"
input <- read_excel(path, range = "A1:B26")
test <- read_excel(path, range = "C1:C26")

result = input %>%
  separate_wider_delim(Data, "|", names = c("R", "F", "M")) %>%
  mutate(across(c(R, F, M), as.integer)) %>%
  mutate(
    r_rank = ntile(desc(R), 5),
    f_rank = ntile(F, 5),
    m_rank = ntile(M, 5)
  ) %>%
  transmute(`Answer Expected` = r_rank * 100 + f_rank * 10 + m_rank)

all.equal(result, test)
# Two cells with different values.
