# Source this to load the project and needed libraries

rm(list = ls())
library('ProjectTemplate')
library(survey)

load.project()

# Commented out to not show the head of the dataset

# for (dataset in project.info$data)
# {
#   message(paste('Showing top 5 rows of', dataset))
#   print(head(get(dataset)))
# }
