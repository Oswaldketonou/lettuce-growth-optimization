# =========================================================
# Lettuce Growth Optimization
# Data Cleaning & Feature Engineering Pipeline
# Author: Waldo Ketonou
# =========================================================

# ---------------------------------------------------------
# 1. Load Libraries
# ---------------------------------------------------------
library(tidyverse)

# ---------------------------------------------------------
# 2. Load Raw Data
# ---------------------------------------------------------
# Using a relative path ensures reproducibility
raw_data <- read_csv("data/lettuce_raw.csv")

# Inspect structure
glimpse(raw_data)

# ---------------------------------------------------------
# 3. Data Cleaning
# ---------------------------------------------------------

clean_data <- raw_data %>%
  # Remove missing or duplicated rows
  distinct() %>%
  drop_na() %>%

  # Standardize column names
  rename(
    temp = Temperature,
    humidity = Humidity,
    light = LightExposure,
    water = WateringFrequency,
    height = PlantHeight,
    biomass = Biomass
  ) %>%

  # Convert categorical variables
  mutate(
    water = as.factor(water)
  )

# ---------------------------------------------------------
# 4. Feature Engineering
# ---------------------------------------------------------

clean_data <- clean_data %>%
  mutate(
    # Growth rate: height relative to biomass
    growth_rate = height / biomass,

    # Temperature range category
    temp_range = case_when(
      temp < 18 ~ "Low",
      temp >= 18 & temp <= 24 ~ "Optimal",
      temp > 24 ~ "High"
    ),

    # Light exposure category
    light_category = case_when(
      light < 8 ~ "Low",
      light >= 8 & light <= 12 ~ "Moderate",
      light > 12 ~ "High"
    ),

    # Humidity category
    humidity_category = case_when(
      humidity < 40 ~ "Low",
      humidity >= 40 & humidity <= 60 ~ "Optimal",
      humidity > 60 ~ "High"
    )
  )

# ---------------------------------------------------------
# 5. Final Validation
# ---------------------------------------------------------
summary(clean_data)
glimpse(clean_data)

# ---------------------------------------------------------
# 6. Export Cleaned Dataset
# ---------------------------------------------------------
write_csv(clean_data, "data/lettuce_cleaned_engineered.csv")

# End of Pipeline
# =========================================================
