# Financial Constraints and Higher Education Persistence

## Overview
This repository contains the replication code for the study **"Financial Constraints and Higher Education Persistence: Evidence from Administrative Data in Portugal."**

The project investigates the causal relationship between liquidity constraints (measured by late tuition payments) and university dropout rates. Using administrative data from the Polytechnic Institute of Portalegre ($N=4,424$), I employ **Ordinary Least Squares (OLS)** and **Propensity Score Weighting (IPW)** to estimate treatment effects while controlling for socioeconomic background, academic performance, and displacement status.

## Key Findings
* **Baseline (OLS):** Late tuition payments are associated with a **56.9 percentage point increase** in the probability of dropout ($p < 0.05$).
* **Robustness (IPW):** After balancing covariates using Propensity Score Weighting, the effect attenuates to **44.8 percentage points** but remains statistically significant, suggesting that financial instability is a critical determinant of retention even after accounting for selection bias.

## Methodology & Tools
* **Language:** R
* **Key Packages:**
    * `tidyverse` (Data wrangling)
    * `car` (Multicollinearity diagnostics)
    * `WeightIt` (Propensity Score Weighting)
* **Identification Strategy:** Selection on observables is addressed via inverse probability weighting (IPW) to adjust for confounding variables such as parental occupation and prior qualifications.

## Data Source & Codebook
**Source:** The data was originally collected by the **Polytechnic Institute of Portalegre** (Realinho et al., 2022).
* *Note:* The original source URL is no longer active. The dataset has been archived in this repository (`student_dropout_data.csv`) to ensure reproducibility.

### Variable Descriptions
| Variable | Description |
| :--- | :--- |
| **Target** | The outcome variable: "Graduate", "Enrolled", or "Dropout". |
| **Tuition.fees.up.to.date** | Binary: 1 if tuition is paid on time, 0 otherwise. |
| **Scholarship.holder** | Binary: 1 if the student holds a scholarship, 0 otherwise. |
| **Father.s.occupation** | Categorical: Job classification of the father (ISCO-08 standards). |
| **Mother.s.occupation** | Categorical: Job classification of the mother (ISCO-08 standards). |
| **Displaced** | Binary: 1 if the student moved from their home region to attend. |
| **Previous.qualification** | Ordinal: Highest qualification prior to enrollment. |

## Usage
To replicate the analysis:
1. Clone this repository.
2. Open `analysis.R` in RStudio.
3. Run the script (dependencies will need to be installed).
