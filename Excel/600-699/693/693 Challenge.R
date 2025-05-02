library(tidyverse)
library(readxl)

path = "Excel/693 Generate a sequence.xlsx"
test  = read_excel(path, range = "A1:A101")

start = list(1, 2, 3, 4)
for (i in 1:50) {
  start = append(start, c(sum(start[[length(start) - 3]], start[[length(start) - 1]]),
                          sum(start[[length(start) - 2]], start[[length(start)]])))
}
df = data.frame(a = unlist(start[1:100]))
all.equal(df$a, test$`Answer Expected`)
# TRUE