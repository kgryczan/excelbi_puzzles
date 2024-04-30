library(tidyverse)
library(gt)


df = data.frame(Eiffel = c("|", "/\\", "00",
                           "XX","XX","XX",
                           "XXXX","XXXX","XXXX",
                           "XXXXXXX","XXXXXXX","XXXXXXX",
                           "XXXXXXXXX","XXXXXXXXX","XXXXXXXXX",
                           paste0(strrep("X", 4), strrep("_", 6), strrep("X", 4)),
                           paste0(strrep("X", 4), strrep("_", 8), strrep("X", 4)),
                           strrep("X", 18),
                           paste0(strrep("X", 5), strrep("_", 12), strrep("X", 5)),
                           paste0(strrep("X", 6), strrep("_", 16), strrep("X", 6))
                  ))

df_gt = df %>% 
  gt() %>% 
  cols_align(align = "center") 
df_gt
