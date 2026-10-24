# ==============================================================================
# Script Name: 05_second_language.py
# Course: ECO346 - Assignment 1
# Description: Literacy rate by age band and sex using Python (Variant 0)
# ==============================================================================

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# 1. Load the dataset saved from R
df = pd.read_csv("punjab_rural.csv")

# 2. Filter literacy sample: Age 10-64, non-missing literate
lit_data = df[(df['literate'].notna()) & (df['age'] >= 10) & (df['age'] <= 64)].copy()

# Define sex label
lit_data['sex_label'] = lit_data['sex'].apply(lambda x: 'Men' if x == 1 else 'Women')

# Define 5-year age bands and midpoints
bins = [9.5, 14.5, 19.5, 24.5, 29.5, 34.5, 39.5, 44.5, 49.5, 54.5, 59.5, 64.5]
labels = ["10-14", "15-19", "20-24", "25-29", "30-34", "35-39", 
          "40-44", "45-49", "50-54", "55-59", "60-64"]
midpoints = [12, 17, 22, 27, 32, 37, 42, 47, 52, 57, 62]

lit_data['age_band'] = pd.cut(lit_data['age'], bins=bins, labels=labels)

# Map midpoints
midpoint_dict = dict(zip(labels, midpoints))
lit_data['midpoint'] = lit_data['age_band'].map(midpoint_dict)

# 3. Compute weighted mean function
def weighted_mean(group):
    return np.average(group['literate'], weights=group['hhweight']) * 100

# Group by age band and sex
grouped = lit_data.groupby(['age_band', 'midpoint', 'sex_label'], observed=True).apply(
    lambda g: pd.Series({
        'n_obs': len(g),
        'lit_rate': weighted_mean(g)
    })
).reset_index()

grouped['is_thin'] = grouped['n_obs'] < 30
print(grouped)

# 4. Plotting using Matplotlib
fig, ax = plt.subplots(figsize=(8, 6))

for sex, color in [('Men', 'blue'), ('Women', 'red')]:
    sub = grouped[grouped['sex_label'] == sex]
    ax.plot(sub['midpoint'], sub['lit_rate'], label=sex, color=color, linewidth=2)
    
    # Normal vs Thin markers
    normal = sub[~sub['is_thin']]
    thin = sub[sub['is_thin']]
    ax.scatter(normal['midpoint'], normal['lit_rate'], color=color, s=50, zorder=5)
    ax.scatter(thin['midpoint'], thin['lit_rate'], facecolors='none', edgecolors=color, s=50, zorder=5)

ax.set_ylim(0, 100)
ax.set_xlim(10, 67)
ax.set_xlabel("Age Band (Midpoint)")
ax.set_ylabel("Weighted Literacy Rate (%)")
ax.set_title("Gender Gap in Literacy (Python Second Language)")
ax.legend()
plt.tight_layout()

# Save figure as SVG in figures folder
plt.savefig("figures/literacy_py.svg", format="svg")
print("Python figure saved successfully to figures/literacy_py.svg!")
