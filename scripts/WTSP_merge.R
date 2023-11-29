# Daniel Redwine
# 29 Nov 23

# This script is to merge all of the current shared WTSP datasets for use in various projects
# The best way to establish a working directory in R is to use an R project.
# Start a new project with file, new project, and new directory.
# The location of the .Rproj file in the project folder is the reference for the working directory.
# In the project folder create a folder called "scripts" and a folder called "data".
# Put this script into "scripts"

# The three datasets which will be utilized for this document are the WTSP banding data 
# google sheet, the WTSP feather data google sheet, and the WTSP sex and morph data google sheet.
# To download each google sheet choose file, download, and download as comma separated values(.csv).
# Files that are .csv are compatible with R and do not contain additional formatting beyond  the values.
# Once all three files are downloaded, move them into the "data" folder within your R project folder.
# For this script to work name the WTSP banding data "banding_data", the WTSP feather data "feather_data", and the WTSP sex and morph data "sm_data".

# Modifying Datasets
# The feather dataset has two rows of headers.
# R will only recognize one of these as the header, so we must condense it to one row.
# R also does not work well with spaces and characters such as the hashtag and parentheses, so we will remove spaces and characters in this section.
# Pay close attention to capitalization, as R needs the cases to be matched entirely.</li>
# Move New_Recap to the second row.
# Move P4_Yes_No and R6_Yes_No to the second row. 
# Move P4Mass to the second row and change it to P4Mass_mg. 
# Move P4Length to the second row and change it to P4Length_mm. 
# Move R6Mass to the second row and change it to R6Mass_mg. 
# Move R6Length to the second row and change it to R6length_mm. 
# Move R6Image to the second row 
# The prefix ij will be used to notate ImageJ. 
# Change comments to ij_Comments 
# Change # measured to ij_num_Measured.
# Change Measurement (mm) to ij_Measurement_mm.
# Change Avg per Bar to ij_Avg_per_Bar.
# Delete the first row of the dataset.
# Remove the average in the bottom row of the datset. We can always just calculate this in R.

# For this we will use the tidyverse package, paste the code below into the command line and use ctrl + enter to run it if you do not have tidyverse
# install.packages("tidyverse")

# load the package tidyverse which contains dplyr, ggplot2, readr, and tidyr
library(tidyverse)

# Import the banding, feather, and sex and morph datasets from the data folder
banding_data <- read.csv("data/banding_data.csv")
feather_data <- read.csv("data/feather_data.csv")
sm_data <- read.csv("data/sm_data.csv")

# Remove both the PCRsex and PCRMorph columns from the banding_data to ensure it does not duplicate columns when merging with the sex and morph dataset
banding_data <- select(banding_data, -c("PCRsex", "PCRMorph"))

# Select the columns from the feather_data that need to be added to the banding_data ensuring that the columns included match and are not duplicated
feather_data <- select(feather_data, "Record", "P4Mass_mg", "P4Length_mm", "P4Image", "R6Mass_mg", "R6Length_mm", "R6Image", "ij_Comments", "ij_num_Measured", "ij_Measurement_mm", "ij_Avg_per_Bar")

# Select PCRsex and PCRMorph from the sex and morph data to ensure that the sex and morph data added to banding_data is the most up to date version
sm_data <- select(sm_data, "SampleID", "PCRsex", "PCRMorph")

# full_join() to merge banding data and feather data, which keeps all rows and columns from both datasets
# merging by record as both include repeated measures and record is unique for these sets
bf_data <- full_join(banding_data, feather_data, by = "Record")

# full_join() to merge the already merged dataset with the sex and morph data 
# We are joining by SampleID here as record is not included in the sex and morph dataset and sex and morph remain constant throughout time 
total_data <- full_join(bf_data, sm_data, by = "SampleID")

# For the project you wish to complete simply use the code below, and write the factors you need from the total_data into the different "" slots which you can add more of. 
# project_data <- select(total_data, "columns", "you", "want", "to", "use")

# To merge any additional data use the code below:
# project_data <- full_join(project_data, your_data, by = "SampleID or Record")

# To change factors to factors and numerics to numerics for fields R might have read incorrectly:
#  project_data$column_header <- as.factor(project_data$column_header)
#  project_data$column_header <- as.numeric(wing_sex_clean$column_header)

# To filter out any fields with missing data:
# filter keeps data which matches the conditions
# the symbol for or in dplyr is |, so we are filtering out data which are not x, X, NA, or blank. 
# project_data <- project_data %>% dplyr::filter(column_header != "x" | column_header != "X" | column_header != "NA" | column_header != "")