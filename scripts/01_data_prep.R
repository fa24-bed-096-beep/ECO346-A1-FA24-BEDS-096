# ==============================================================================
# Script Name: 01_data_prep.R
# Course: ECO346 - Assignment 1
# Description: Data preparation, merging, and filtering for Variant 0 (Punjab Rural)
# ==============================================================================

# Load required libraries
library(tidyverse)

# Load datasets from the data directory
person_data <- read_csv("data/pslm_person_subset.csv")
hh_data     <- read_csv("data/pslm_hh_subset.csv")

# Merge household and person datasets using 'hhid'
merged_data <- hh_data %>%
  inner_join(person_data, by = "hhid")

# Check unique values of prov_code and urban_rural to confirm correct codes
unique(merged_data$prov_code)
unique(merged_data$urban_rural)

# Filter for Variant 0: Punjab Rural 
punjab_rural_data <- merged_data %>%
  filter(prov_code == 2, urban_rural == 2)

# Check the filtered data dimensions and preview
dim(punjab_rural_data)
head(punjab_rural_data)