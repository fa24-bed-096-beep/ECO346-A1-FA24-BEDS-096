# ==============================================================================
# Script Name: 03_literacy.R
# Course: ECO346 - Assignment 1
# Description: Weighted literacy rate by age band and sex (Variant 0)
# ==============================================================================

library(tidyverse)
library(svglite)

# Custom weighted mean function
weighted_mean_custom <- function(x, w) {
  sum(w * x, na.rm = TRUE) / sum(w, na.rm = TRUE)
}

# 1. Filter literacy sample: Age 10-64, non-missing literate
lit_data <- punjab_rural_data %>%
  filter(!is.na(literate), age >= 10, age <= 64) %>%
  mutate(
    sex_label = ifelse(sex == 1, "Men", "Women"),
    # Define 5-year age bands
    age_band = cut(
      age,
      breaks = seq(9.5, 64.5, by = 5),
      labels = c("10-14", "15-19", "20-24", "25-29", "30-34", "35-39", 
                 "40-44", "45-49", "50-54", "55-59", "60-64")
    ),
    # Band midpoints
    midpoint = case_when(
      age_band == "10-14" ~ 12, age_band == "15-19" ~ 17,
      age_band == "20-24" ~ 22, age_band == "25-29" ~ 27,
      age_band == "30-34" ~ 32, age_band == "35-39" ~ 37,
      age_band == "40-44" ~ 42, age_band == "45-49" ~ 47,
      age_band == "50-54" ~ 52, age_band == "55-59" ~ 57,
      age_band == "60-64" ~ 62
    )
  )

# 2. Compute Band Table (Count, Weighted Literacy Rate, Thin cell indicator)
band_table <- lit_data %>%
  group_by(age_band, midpoint, sex_label) %>%
  summarise(
    n_obs = n(),
    lit_rate = weighted_mean_custom(literate, hhweight) * 100,
    .groups = "drop"
  ) %>%
  mutate(is_thin = n_obs < 30)

# Print Band Table for verification and reporting
print(as.data.frame(band_table))

# Find the band with the largest gap between men and women
gap_data <- band_table %>%
  select(age_band, midpoint, sex_label, lit_rate) %>%
  pivot_wider(names_from = sex_label, values_from = lit_rate) %>%
  mutate(gap = abs(Men - Women)) %>%
  arrange(desc(gap))

max_gap_band <- gap_data[1, ]
print(paste("Largest gap is in band:", max_gap_band$age_band, "with gap:", round(max_gap_band$gap, 1), "%"))

# 3. Plotting the Relationship
labels_data <- band_table %>%
  filter(midpoint == 62)

p3 <- ggplot(band_table, aes(x = midpoint, y = lit_rate, color = sex_label, group = sex_label)) +
  geom_line(size = 1) +
  geom_point(aes(shape = is_thin, fill = sex_label), size = 3) +
  scale_shape_manual(values = c("FALSE" = 21, "TRUE" = 1)) +
  scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, by = 20)) +
  scale_x_continuous(breaks = seq(12, 62, by = 5)) +
  # Direct annotation for largest gap
  annotate(
    "text",
    x = max_gap_band$midpoint,
    y = max(max_gap_band$Men, max_gap_band$Women) + 5,
    label = paste0("Largest Gap (", round(max_gap_band$gap, 1), "%)"),
    fontface = "bold", size = 3.5, color = "darkred"
  ) +
  # Direct series labels (No legend)
  geom_text(
    data = labels_data,
    aes(x = midpoint + 1.5, y = lit_rate, label = sex_label),
    hjust = 0, fontface = "bold"
  ) +
  coord_cartesian(xlim = c(10, 67)) +
  labs(
    title = "Gender Gap in Literacy Narrows Significantly Among Younger Rural Punjab Cohorts",
    x = "Age Band (Midpoint)",
    y = "Weighted Literacy Rate (%)",
    caption = "Source: PSLM 2019-20. Sample: Persons aged 10-64. Weighted by hhweight. Hollow markers indicate thin cells (n < 30)."
  ) +
  theme_minimal() +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold", size = 10),
    plot.caption = element_text(size = 8, hjust = 0)
  )

# Save as SVG
ggsave("figures/literacy.svg", plot = p3, width = 8, height = 6, device = "svg")
print("Figure saved successfully to figures/literacy.svg!")