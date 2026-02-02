###############################################
# Lettuce Growth Optimization - EDA Script
# Author: Waldo Ketonou
# Purpose: Explore environmental drivers of Growth_Days
###############################################

# -------------------------------
# 0. Load libraries & data
# -------------------------------
library(tidyverse)
library(lubridate)
library(ggplot2)
library(corrplot)

# Assumes `lettuce` is already loaded in the environment
# glimpse(lettuce)  # Uncomment to quickly inspect structure


# -------------------------------
# 1. Missing values audit
# -------------------------------
# Goal: Check data completeness across all variables

missing_summary <- lettuce %>%
  summarise(across(everything(), ~ sum(is.na(.)))) %>%
  pivot_longer(cols = everything(),
               names_to = "Variable",
               values_to = "Missing_Count") %>%
  arrange(desc(Missing_Count))

print(missing_summary)


# -------------------------------
# 2. Distributions of raw environmental variables
# -------------------------------
# Goal: Understand operating ranges and variability of key inputs

lettuce %>%
  select(Temperature, Humidity, TDS_ppm, pH) %>%
  pivot_longer(cols = everything(),
               names_to = "Variable",
               values_to = "Value") %>%
  ggplot(aes(x = Value)) +
  geom_histogram(bins = 30, fill = "steelblue", color = "white") +
  facet_wrap(~ Variable, scales = "free") +
  theme_minimal() +
  labs(
    title = "Distribution of Raw Environmental Variables",
    x = "Value",
    y = "Count"
  )


# -------------------------------
# 3. Distribution of Growth_Days
# -------------------------------
# Goal: See how long plants typically take to reach maturity

ggplot(lettuce, aes(x = Growth_Days)) +
  geom_histogram(bins = 30, fill = "darkgreen", color = "white") +
  theme_minimal() +
  labs(
    title = "Distribution of Growth Days",
    x = "Growth Days",
    y = "Count"
  )


# -------------------------------
# 4. Rolling 3-day environmental trends
# -------------------------------
# Goal: Visualize smoothed environmental patterns over time

lettuce %>%
  pivot_longer(cols = ends_with("Roll3"),
               names_to = "Variable",
               values_to = "Value") %>%
  ggplot(aes(x = Date, y = Value, color = Variable)) +
  geom_line(alpha = 0.7) +
  theme_minimal() +
  labs(
    title = "Rolling 3-Day Averages Over Time",
    x = "Date",
    y = "3-Day Rolling Average"
  )


# -------------------------------
# 5. Correlation matrix (numeric variables)
# -------------------------------
# Goal: Identify relationships and potential predictors of Growth_Days

numeric_vars <- lettuce %>%
  select(where(is.numeric))

cor_matrix <- cor(numeric_vars, use = "complete.obs")

corrplot(
  cor_matrix,
  method = "color",
  type = "upper",
  tl.cex = 0.7,
  title = "Correlation Matrix",
  mar = c(0, 0, 2, 0)
)


# -------------------------------
# 6. Env_Score vs Growth_Days
# -------------------------------
# Goal: Test whether better environmental conditions relate to faster growth

ggplot(lettuce, aes(x = Env_Score, y = Growth_Days)) +
  geom_point(alpha = 0.5, color = "purple") +
  geom_smooth(method = "lm", se = FALSE, color = "black") +
  theme_minimal() +
  labs(
    title = "Env_Score vs Growth_Days",
    x = "Environmental Score",
    y = "Growth Days"
  )


# -------------------------------
# 7. Optimal condition flags over time
# -------------------------------
# Goal: Track how often each condition is within its optimal range

lettuce %>%
  select(Date, Temp_Optimal, Humidity_Optimal, pH_Optimal, TDS_Optimal) %>%
  pivot_longer(cols = -Date,
               names_to = "Condition",
               values_to = "Optimal") %>%
  ggplot(aes(x = Date, fill = Optimal)) +
  geom_bar(position = "fill") +
  facet_wrap(~ Condition, ncol = 1) +
  theme_minimal() +
  labs(
    title = "Proportion of Optimal Conditions Over Time",
    x = "Date",
    y = "Proportion"
  )


# -------------------------------
# 8. Composite optimal score breakdown
# -------------------------------
# Goal: Compare distributions of each optimality component

lettuce %>%
  select(Temp_Optimal_num,
         Humidity_Optimal_num,
         pH_Optimal_num,
         TDS_Optimal_num) %>%
  pivot_longer(cols = everything(),
               names_to = "Condition",
               values_to = "Score") %>%
  ggplot(aes(x = Condition, y = Score)) +
  geom_boxplot(fill = "orange") +
  theme_minimal() +
  labs(
    title = "Distribution of Optimal Condition Scores",
    x = "Condition Component",
    y = "Score"
  )


# -------------------------------
# 9. Growth patterns by Plant_ID
# -------------------------------
# Goal: Explore plant-level variation in growth duration

ggplot(lettuce, aes(x = Growth_Days, group = Plant_ID)) +
  geom_density(alpha = 0.3, fill = "forestgreen") +
  theme_minimal() +
  labs(
    title = "Growth Days Density by Plant",
    x = "Growth Days",
    y = "Density"
  )


# -------------------------------
# 10. Summary statistics for export
# -------------------------------
# Goal: Create a compact numeric summary for reporting / Tableau

eda_summary <- lettuce %>%
  summarise(
    across(
      where(is.numeric),
      list(
        mean = ~ mean(.x, na.rm = TRUE),
        sd   = ~ sd(.x, na.rm = TRUE),
        min  = ~ min(.x, na.rm = TRUE),
        max  = ~ max(.x, na.rm = TRUE)
      )
    )
  )

# Write summary to CSV (for dashboard or documentation)
write_csv(eda_summary, "lettuce_eda_summary.csv")


###############################################
# BOOKMARK: NEXT STEP IN PROJECT
# ---------------------------------
# B. Move from EDA to modeling & KPIs:
#    - Define target KPI(s) (e.g., Growth_Days threshold)
#    - Build simple models (linear/logistic) using Env_Score & key drivers
#    - Prepare features and outputs for Tableau dashboard
###############################################
