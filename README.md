# ECO346 Assignment 1 - FA24-BEDS-096
This repository contains the code, data subsets, figures, presentation, and analysis for **ECO346 Assignment 1 (Variant 0: Punjab Rural)**.
## Project Overview
- **Variant:** Variant 0 (Punjab Rural)
- **Student ID:** FA24-BEDS-096
- **Course:** ECO346 - Economics with Data Science
This repository contains the code, data subsets, figures, presentation, and analysis for **ECO346 Assignment 1 (Variant 0: Punjab Rural)**.
## Project Structure
- **`data/`**: Contains `pslm_person_subset.csv` and `pslm_hh_subset.csv`.
- **`scripts/`**: Contains R and Python scripts for data cleaning, distributions, and literacy analysis.
- **`figures/`**: Contains generated SVG visualizations (`default.svg`, `distribution.svg`, `literacy.svg`).
- **`slides/`**: Contains the 4-slide presentation deck (`FA24-BEDS-096.pptx`).

## Age Band Table (Literacy Rate by Age and Sex)
    age_band   midpoint sex_label n_obs  lit_rate         is_thin
1     10-14        12       Men   954    84.39515          FALSE
2     10-14        12     Women   885    88.67362          FALSE
3     15-19        17       Men   895    86.70379          FALSE
4     15-19        17     Women   838    89.35458          FALSE
5     20-24        22       Men   785    84.14053          FALSE
6     20-24        22     Women   728    82.66537          FALSE
7     25-29        27       Men   568    78.77122          FALSE
8     25-29        27     Women   651    76.17779          FALSE
9     30-34        32       Men   525    82.71872          FALSE
10    30-34        32     Women   539    70.45191          FALSE
11    35-39        37       Men   477    79.81595          FALSE
12    35-39        37     Women   503    71.14708          FALSE
13    40-44        42       Men   420    77.58443          FALSE
14    40-44        42     Women   463    60.46620          FALSE
15    45-49        47       Men   420    71.34910          FALSE
16    45-49        47     Women   378    54.42717          FALSE
17    50-54        52       Men   367    64.09163          FALSE
18    50-54        52     Women   346    45.08366          FALSE
19    55-59        57       Men   257    68.36064          FALSE
20    55-59        57     Women   224    42.39930          FALSE
21    60-64        62       Men   234    72.66359          FALSE
22    60-64        62     Women   175    33.39485          FALSE

## Interpretation & Summary
- **Distribution:** Education spending is right-skewed; the weighted median is Rs 15,000 and the unweighted median is Rs 14,000.
- **Relationship:** A significant gender gap exists in older cohorts that narrows considerably among younger generations. The largest gap appears in the 60–64 age band.
