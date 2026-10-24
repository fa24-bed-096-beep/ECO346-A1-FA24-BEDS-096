# ==============================================================================
# Script Name: 04_makeover.R
# Course: ECO346 - Assignment 1
# Description: Default literacy scatter plot for makeover comparison (Variant 0)
# ==============================================================================

library(tidyverse)
library(svglite)

# 1. Filter literacy sample (same sample as Question 3)
lit_data_default <- punjab_rural_data %>%
  filter(!is.na(literate), age >= 10, age <= 64)

# 2. Draw default ggplot scatter plot with NO custom styling (R defaults)
p_default <- ggplot(lit_data_default, aes(x = age, y = literate)) +
  geom_point()

# 3. Save as default.svg in figures folder
if (!dir.exists("figures")) dir.create("figures")
ggsave("figures/default.svg", plot = p_default, width = 8, height = 6, device = "svg")

print("Default figure saved successfully to figures/default.svg!")