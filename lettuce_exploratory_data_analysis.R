# =========================================================
# Lettuce Growth Optimization
# Exploratory Data Analysis (EDA)
# Author: Waldo Ketonou
# =========================================================

# ---------------------------------------------------------
# 1. Load Necessary Libraries
# ---------------------------------------------------------
library(tidyverse)
library(lubridate)
library(ggplot2)
library(corrplot)

# ---------------------------------------------------------
# 2. Preview the Dataset
# ---------------------------------------------------------
glimpse(lettuce)


# ---------------------------------------------------------
# 3. Check for Missing Values
# ---------------------------------------------------------
lettuce %>%
  summarise(across(everything(), ~ sum(is.na(.)))) %>%
  pivot_longer(
    cols = everything(),
    names_to = "Variable",
    values_to = "Missing_Count"
  ) %>%
  arrange(desc(Missing_Count))


# ---------------------------------------------------------
# 4. Distribution Plots for Raw Measurements
# ---------------------------------------------------------
lettuce %>%
  select(Temperature, Humidity, TDS_ppm, pH) %>%
  pivot_longer(
    cols = everything(),
    names_to = "Variable",
    values_to = "Value"
  ) %>%
  ggplot(aes(x = Value)) +
  geom_histogram(bins = 30, fill = "steelblue", color = "white") +
  facet_wrap(~ Variable, scales = "free") +
  theme_minimal() +
  labs(title = "Distribution of Raw Environmental Variables")


# ---------------------------------------------------------
# 5. Distribution of Growth_Days
# ---------------------------------------------------------
ggplot(lettuce, aes(x = Growth_Days)) +
  geom_histogram(bins = 30, fill = "darkgreen", color = "white") +
  theme_minimal() +
  labs(
    title = "Distribution of Growth Days",
    x = "Growth Days",
    y = "Count"
  )


# ---------------------------------------------------------
# 6. Time-Series Trends for Rolling Averages
# ---------------------------------------------------------
lettuce %>%
  pivot_longer(
    cols = ends_with("Roll3"),
    names_to = "Variable",
    values_to = "Value"
  ) %>%
  ggplot(aes(x = Date, y = Value, color = Variable)) +
  geom_line(alpha = 0.7) +
  theme_minimal() +
  labs(title = "Rolling 3-Day Averages Over Time")


# ---------------------------------------------------------
# 7. Correlation Matrix for Numeric Variables
# ---------------------------------------------------------
# Select numeric columns
numeric_vars <- lettuce %>%
  select(where(is.numeric))

# Compute correlation matrix
cor_matrix <- cor(numeric_vars, use = "complete.obs")

# Visualize correlation matrix
corrplot(
  cor_matrix,
  method = "color",
  type = "upper",
  tl.cex = 0.7,
  title = "Correlation Matrix"
)


# ---------------------------------------------------------
# 8. Environmental Score vs Growth Days
# ---------------------------------------------------------
ggplot(lettuce, aes(x = Env_Score, y = Growth_Days)) +
  geom_point(alpha = 0.5, color = "purple") +
  geom_smooth(method = "lm", se = FALSE, color = "black") +
  theme_minimal() +
  labs(
    title = "Env_Score vs Growth_Days",
    x = "Environmental Score",
    y = "Growth Days"
  )


# ---------------------------------------------------------
# 9. Optimal Condition Flags Over Time
# ---------------------------------------------------------
lettuce %>%
  select(Date, Temp_Optimal, Humidity_Optimal, pH_Optimal, TDS_Optimal) %>%
  pivot_longer(
    cols = -Date,
    names_to = "Condition",
    values_to = "Optimal"
  ) %>%
  ggplot(aes(x = Date, fill = Optimal)) +
  geom_bar(position = "fill") +
  facet_wrap(~ Condition, ncol = 1) +
  theme_minimal() +
  labs(
    title = "Proportion of Optimal Conditions Over Time",
    y = "Proportion"
  )


# ---------------------------------------------------------
# 10. Composite Optimal Score Breakdown
# ---------------------------------------------------------
lettuce %>%
  select(
    Temp_Optimal_num,
    Humidity_Optimal_num,
    pH_Optimal_num,
    TDS_Optimal_num
  ) %>%
  pivot_longer(
    cols = everything(),
    names_to = "Condition",
    values_to = "Score"
  ) %>%
  ggplot(aes(x = Condition, y = Score)) +
  geom_boxplot(fill = "orange") +
  theme_minimal() +
  labs(title = "Distribution of Optimal Condition Scores")


# ---------------------------------------------------------
# 11. Growth Trend by Plant_ID
# ---------------------------------------------------------
ggplot(lettuce, aes(x = Growth_Days, group = Plant_ID)) +
  geom_density(alpha = 0.3, fill = "forestgreen") +
  theme_minimal() +
  labs(
    title = "Growth Days Density by Plant",
    x = "Growth Days"
  )


# ---------------------------------------------------------
# 12. Save EDA Summary
# ---------------------------------------------------------
eda_summary <- lettuce %>%
  summarise(
    across(
      where(is.numeric),
      list(mean = mean, sd = sd, min = min, max = max),
      na.rm = TRUE
    )
  )

write_csv(eda_summary, "lettuce_eda_summary.csv")


# ---------------------------------------------------------
# 13. Reproducibility Info
# ---------------------------------------------------------
sessionInfo()

# End of EDA Script
# =========================================================
