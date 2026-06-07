library(tidyverse)
library(readxl)

path <- "300-399/398/PQ_Challenge_398.xlsx"
input <- read_excel(path, range = "A1:D27")
test <- read_excel(path, range = "F1:K7")

result = input %>%
  mutate(
    ProgressPct = mean(Cleared),
    CurrentStage = if_else(
      ProgressPct == 0,
      "Not Started",
      last(StageName[Cleared])
    ),
    NextStage = case_when(
      ProgressPct == 1 ~ "Completed",
      ProgressPct == 0 ~ first(StageName[!Cleared]),
      TRUE ~ StageName[match(CurrentStage, StageName) + 1]
    ),
    Status = if_else(
      ProgressPct == 0,
      "Not Started",
      if_else(ProgressPct == 1, "Completed", "In Progress")
    ),
    ProcessIssue = if_else(
      any(StageNo < StageNo[StageName == CurrentStage] & !Cleared),
      "Yes",
      "No",
      missing = "No"
    ),
    .by = CaseID
  ) %>%
  distinct(CaseID, CurrentStage, NextStage, Status, ProcessIssue, ProgressPct)

all.equal(result, test)
# [1] TRUE
