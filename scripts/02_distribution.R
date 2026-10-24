# ==============================================================================
# Script Name: 02_distribution.R
# Course: ECO346 - Assignment 1
# Description: Weighted histogram and summary statistics for education spending (Variant 0)
# ==============================================================================

library(tidyverse)
library(svglite)

# 1. Filter students (ed_total > 0) from the prepared Punjab Rural dataset
students_data <- punjab_rural_data %>%
  filter(!is.na(ed_total), ed_total > 0)

# 2. Log10 transformation and filtering range [2.0, 6.0] (Rs 100 to Rs 1,000,000)
students_data <- students_data %>%
  mutate(log_ed = log10(ed_total))

filtered_students <- students_data %>%
  filter(log_ed >= 2.0, log_ed <= 6.0)

excluded_count <- nrow(students_data) - nrow(filtered_students)
n_students <- nrow(filtered_students)

print(paste("Number of students:", n_students))
print(paste("Number of students excluded:", excluded_count))

# 3. Custom weighted quantile function as specified in instructions
# (Sort by x, compute cumulative share of weight, find smallest x where share >= p)
weighted_quantile <- function(x, w, p) {
  df <- tibble(x = x, w = w) %>% arrange(x)
  cum_w <- cumsum(df$w)
  total_w <- sum(df$w)
  cum_share <- cum_w / total_w
  df$x[which(cum_share >= p)[1]]
}

# Weighted median (p = 0.5) and percentiles (p = 0.1, p = 0.9)
w_median <- weighted_quantile(filtered_students$ed_total, filtered_students$hhweight, 0.5)
w_p10    <- weighted_quantile(filtered_students$ed_total, filtered_students$hhweight, 0.1)
w_p90    <- weighted_quantile(filtered_students$ed_total, filtered_students$hhweight, 0.9)

# Unweighted median
uw_median <- median(filtered_students$ed_total)

# Ratio of 90th to 10th percentile
p90_p10_ratio <- w_p90 / w_p10

print(paste("Weighted Median:", round(w_median)))
print(paste("Unweighted Median:", round(uw_median)))
print(paste("Weighted 10th Percentile:", round(w_p10)))
print(paste("Weighted 90th Percentile:", round(w_p90)))
print(paste("90/10 Ratio:", round(p90_p10_ratio, 2)))

# 4. Draw the weighted histogram and save as SVG
# Ensure figures directory exists
if (!dir.exists("figures")) dir.create("figures")

p <- ggplot(filtered_students, aes(x = log_ed, weight = hhweight)) +
  geom_histogram(binwidth = 0.1, boundary = 2.0, fill = "steelblue", color = "white") +
  geom_vline(xintercept = log10(w_median), linetype = "dashed", color = "red", size = 1) +
  geom_vline(xintercept = log10(w_p90), linetype = "dashed", color = "darkgreen", size = 1) +
  scale_x_continuous(
    breaks = 2:6,
    labels = c("100", "1,000", "10,000", "100,000", "1,000,000")
  ) +
  labs(
    title = "Annual Education Spending Varies Widely Among Rural Punjab Households",
    subtitle = paste0("Weighted median: Rs ", round(w_median), " | 90th percentile: Rs ", round(w_p90)),
    x = "Annual Education Spending per Student (PKR, log scale)",
    y = "Density per log10 unit",
    caption = "Source: PSLM 2019-20. Sample: Punjab rural students (ed_total > 0, Rs 100 - 1,000,000). Weighted by hhweight."
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 11),
    plot.caption = element_text(size = 8, hjust = 0)
  )

# Save as SVG in figures folder
ggsave("figures/distribution.svg", plot = p, width = 8, height = 6, device = "svg")
print("Figure saved successfully to figures/distribution.svg!")

# Print required Question 2 numbers for submission
cat("--- QUESTION 2 REPORT ---ლო
")
cat("Number of students:", n_students, "\n")
cat("Excluded students:", excluded_count, "\n")
cat("Weighted Median:", round(w_median), "\n")
cat("Unweighted Median:", round(uw_median), "\n")
cat("Weighted 10th Percentile:", round(w_p10), "\n")
cat("Weighted 90th Percentile:", round(w_p90), "\n")
cat("90/10 Ratio:", round(p90_p10_ratio, 2), "\n")
