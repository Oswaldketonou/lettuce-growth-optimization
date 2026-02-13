# =========================================================
# Lettuce Growth Optimization
# Exploratory Data Analysis (EDA)
# Author: Waldo Ketonou
# =========================================================

# ---------------------------------------------------------
# 0. Load Libraries & Data
# ---------------------------------------------------------
library(tidyverse)
library(janitor)
library(zoo)
library(ggcorrplot)

# Load cleaned dataset (reproducible relative path)
lettuce <- read_csv("data/lettuce_cleaned_engineered.csv")

# Inspect structure
glimpse(lettuce)

# ---------------------------------------------------------
# 1. Missing Values Audit
# ---------------------------------------------------------
missing_summary <- lettuce %>%
  summarise(across(everything(), ~ sum(is.na(.)))) %>%
  pivot_longer(cols = everything(), names_to = "variable", values_to = "missing_count")

print(missing_summary)

# ---------------------------------------------------------
# 2. Distributions of Key Variables
# ---------------------------------------------------------

# Temperature distribution
ggplot(lettuce, aes(temp)) +
  geom_histogram(binwidth = 1, fill = "steelblue", color = "white") +
  labs(title = "Temperature Distribution", x = "Temperature (°C)", y = "Count")

# Humidity distribution
ggplot(lettuce, aes(humidity)) +
  geom_histogram(binwidth = 2, fill = "darkgreen", color = "white") +
  labs(title = "Humidity Distribution", x = "Humidity (%)", y = "Count")

# Growth Days distribution
ggplot(lettuce, aes(Growth_Days)) +
  geom_histogram(binwidth = 1, fill = "purple", color = "white") +
  labs(title = "Growth Days Distribution", x = "Days", y = "Count")

# ---------------------------------------------------------
# 3. Rolling Averages (Smoothing Trends)
# ---------------------------------------------------------
lettuce <- lettuce %>%
  arrange(Growth_Days) %>%
  mutate(
    temp_roll = rollmean(temp, k = 5, fill = NA, align = "right"),
    humidity_roll = rollmean(humidity, k = 5, fill = NA, align = "right")
  )

# Rolling temperature trend
ggplot(lettuce, aes(Growth_Days, temp_roll)) +
  geom_line(color = "firebrick") +
  labs(title = "Rolling Average Temperature (5-Day Window)",
       x = "Growth Days", y = "Temperature (°C)")

# ---------------------------------------------------------
# 4. Correlation Matrix
# ---------------------------------------------------------
numeric_vars <- lettuce %>%
  select(temp, humidity, light, water, height, biomass, growth_rate)

cor_matrix <- cor(numeric_vars)

ggcorrplot(cor_matrix, lab = TRUE, type = "lower",
           title = "Correlation Matrix of Key Variables")

# ---------------------------------------------------------
# 5. Environmental Score vs Growth Days
# ---------------------------------------------------------
ggplot(lettuce, aes(Env_Score, Growth_Days)) +
  geom_point(alpha = 0.6, color = "steelblue") +
  geom_smooth(method = "lm", color = "darkred") +
  labs(title = "Environmental Score vs Growth Days",
       x = "Environmental Score", y = "Growth Days")

# ---------------------------------------------------------
# 6. Optimal Condition Flags
# ---------------------------------------------------------
lettuce <- lettuce %>%
  mutate(
    optimal_temp_flag = temp_range == "Optimal",
    optimal_light_flag = light_category == "Moderate",
    optimal_humidity_flag = humidity_category == "Optimal"
  )

optimal_summary <- lettuce %>%
  summarise(
    pct_optimal_temp = mean(optimal_temp_flag) * 100,
    pct_optimal_light = mean(optimal_light_flag) * 100,
    pct_optimal_humidity = mean(optimal_humidity_flag) * 100
  )

print(optimal_summary)

# ---------------------------------------------------------
# 7. Composite Optimality Score
# ---------------------------------------------------------
lettuce <- lettuce %>%
  mutate(
    optimality_score =
      optimal_temp_flag +
      optimal_light_flag +
      optimal_humidity_flag
  )

ggplot(lettuce, aes(optimality_score)) +
  geom_bar(fill = "darkorange") +
  labs(title = "Composite Optimality Score Distribution",
       x = "Score (0–3)", y = "Count")

# ---------------------------------------------------------
# 8. Growth Patterns by Category
# ---------------------------------------------------------
ggplot(lettuce, aes(temp_range, Growth_Days, fill = temp_range)) +
  geom_boxplot() +
  labs(title = "Growth Days by Temperature Range",
       x = "Temperature Category", y = "Growth Days")

ggplot(lettuce, aes(light_category, Growth_Days, fill = light_category)) +
  geom_boxplot() +
  labs(title = "Growth Days by Light Exposure Category",
       x = "Light Category", y = "Growth Days")

# ---------------------------------------------------------
# 9. Summary Statistics Export
# ---------------------------------------------------------
summary_stats <- lettuce %>%
  summarise(
    avg_growth_days = mean(Growth_Days),
    avg_temp = mean(temp),
    avg_humidity = mean(humidity),
    avg_light = mean(light),
    avg_growth_rate = mean(growth_rate)
  )

write_csv(summary_stats, "data/lettuce_summary_stats.csv")

# ---------------------------------------------------------
# 10. Reproducibility Info
# ---------------------------------------------------------
sessionInfo()

# End of EDA Script
# =========================================================
