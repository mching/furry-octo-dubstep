# Source this to load the project

rm(list = ls())
library('ProjectTemplate')
load.project()

# Commented out to not show the head of the dataset

# for (dataset in project.info$data)
# {
#   message(paste('Showing top 5 rows of', dataset))
#   print(head(get(dataset)))
# }
