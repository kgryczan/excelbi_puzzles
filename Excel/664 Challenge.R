library(tidyverse)
library(readxl)

path = "Excel/664 Remove Rejected Batches.xlsx"
input = read_excel(path, range = "A3:D16")
test  = read_excel(path, range = "F2:H12")

r1 = setdiff(input$Accept, input$Reject...2)
r2 = setdiff(input$Accept, c(input$Reject...2, input$Reject...3))
r3 = setdiff(input$Accept, c(input$Reject...2, input$Reject...3, input$Reject...4))

longest = max(length(r1), length(r2), length(r3))

result = data.frame(Round1 = c(r1, rep(NA, longest - length(r1))),
                    Round2 = c(r2, rep(NA, longest - length(r2))),
                    Round3 = c(r3, rep(NA, longest - length(r3))))

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE