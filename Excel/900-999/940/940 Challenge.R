library(tidyverse)
library(readxl)

path <- "900-999/940/940 Server Allocation.xlsx"
input <- read_excel(path, range = "A1:C21")
test <- read_excel(path, range = "D1:D21")

server_end <- c()
assigned <- character(nrow(input))

for (i in seq_len(nrow(input))) {
  start <- input$Start_Time[i]
  end <- input$End_Time[i]

  idle <- which(server_end <= start)
  if (length(idle) > 0) {
    s <- idle[1]
    server_end[s] <- end
  } else {
    server_end <- c(server_end, end)
    s <- length(server_end)
  }
  assigned[i] <- paste("Server", s)
}

result <- tibble(`Answer Expected` = assigned)
all.equal(result, test)
# [1] TRUE
