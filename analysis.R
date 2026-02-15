# ------------------------------------------------------------------------------
# Project: Financial Constraints and Higher Education Persistence
# Purpose: Estimate the causal effect of late tuition payments on student dropout
# Data: Administrative records from Polytechnic Institute of Portalegre (N=4,424)
# ------------------------------------------------------------------------------

# --- 1. Setup & Dependencies ---
# Ensure required packages are installed and loaded
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, car, WeightIt)

# --- 2. Data Loading & Cleaning ---
# Load data from local repository (ensure student_dropout_data.csv is in working dir)
df <- read.csv("student_dropout_data.csv")

# Create binary outcome variable (1 = Dropout, 0 = Enrolled/Graduate)
# We treat 'Enrolled' and 'Graduate' as the reference group (Success)
df <- df %>%
  mutate(Dropout.binary = ifelse(Target == "Dropout", 1, 0))

# Check class balance
table(df$Dropout.binary)

# --- 3. Baseline Estimation (OLS) ---
# We use a Linear Probability Model (LPM) for interpretability of coefficients.

model_ols <- lm(Dropout.binary ~ Tuition.fees.up.to.date + Father.s.occupation + 
                  Mother.s.occupation + Displaced + Previous.qualification + 
                  Scholarship.holder, 
                data = df)

print("--- OLS Results ---")
summary(model_ols)

# --- 4. Diagnostics ---
# A. Multicollinearity Check
# We use Variance Inflation Factor (VIF). Values < 5 indicate no severe collinearity.
print("--- VIF Diagnostics ---")
vif(model_ols)

# B. Residual Analysis
# Check for heteroskedasticity patterns
plot(model_ols, which = 1, main = "Diagnostic: Residuals vs Fitted")

# C. Normality Check
# Check if residuals follow normal distribution
plot(model_ols, which = 2, main = "Diagnostic: Q-Q Plot")

# --- 5. Robustness Check: Propensity Score Weighting (IPW) ---
# To address selection bias, we use Inverse Probability Weighting.
# Step 1: Estimate propensity scores (probability of treatment given covariates)
# We use 'ATT' (Average Treatment Effect on the Treated) as the estimand.

weight_model <- weightit(Dropout.binary ~ Tuition.fees.up.to.date + Father.s.occupation + 
                           Mother.s.occupation + Displaced + Previous.qualification + 
                           Scholarship.holder, 
                         data = df, 
                         method = "glm", 
                         estimand = "ATT")

# Step 2: Check balance (Optional)
print("--- Covariate Balance Summary ---")
summary(weight_model)

# Step 3: Estimate Weighted Model
# We run the regression again, weighting observations by the inverse propensity score.
model_ipw <- lm(Dropout.binary ~ Tuition.fees.up.to.date + Father.s.occupation + 
                  Mother.s.occupation + Displaced + Previous.qualification + 
                  Scholarship.holder, 
                data = df, 
                weights = weight_model$weights)

print("--- Propensity Score Weighted Results (IPW) ---")
summary(model_ipw)
