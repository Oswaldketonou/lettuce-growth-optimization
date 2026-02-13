# =========================================================
# Lettuce Growth Optimization
# Data Cleaning & Feature Engineering Pipeline
# Author: Waldo Ketonou
# =========================================================

# ---------------------------------------------------------
# 1. Load Libraries
# ---------------------------------------------------------
# Packages for data manipulation and visualization
library(tidyverse)

# Working with dates (parsing, converting, etc.)
library(lubridate)

# Rolling calculations (moving averages)
library(zoo)

# ---------------------------------------------------------
# 2. Load Raw Dataset
# ---------------------------------------------------------
# Read the raw lettuce dataset from an .xltx file
lettuce_raw <- readxl::read_xlsx("data/lettuce_dataset.xltx")

# Inspect structure and summary of the raw data
summary(lettuce_raw)

# Create a working copy to preserve the original
lettuce <- lettuce_raw


# ---------------------------------------------------------
# 3. Initial Structure Checks
# ---------------------------------------------------------
# Check date column structure
str(lettuce$Date)

# General dataset summary
summary(lettuce)


# ---------------------------------------------------------
# 4. Rename Columns (No Structural Changes)
# ---------------------------------------------------------
# Standardizing column names for clarity
lettuce <- lettuce %>%
  rename(
    Plant_ID    = Plant_ID,            # Unique identifier for each plant
    Temperature = `Temperature (°C)`,  # Temperature in Celsius
    Humidity    = `Humidity (%)`,      # Humidity (fraction or percent)
    pH          = `pH Level`,          # pH level
    TDS_ppm     = `TDS Value (ppm)`,   # Total dissolved solids (ppm)
    Growth_Days = `Growth Days`        # Days since planting
  )

# Note:
# If Humidity were stored as a fraction (e.g., 0.65), convert using:
# lettuce <- lettuce %>% mutate(Humidity = Humidity * 100)
# Not needed here.


# ---------------------------------------------------------
# 5. Handle Duplicates & Missing Values
# ---------------------------------------------------------
# Count duplicate rows
lettuce %>%
  duplicated() %>%
  sum()

# Remove duplicate rows if present
lettuce <- lettuce %>%
  distinct()

# Count missing values per column
lettuce %>%
  summarise(across(everything(), ~ sum(is.na(.))))

# Remove rows missing critical fields
lettuce <- lettuce %>%
  filter(
    !is.na(Date),
    !is.na(Temperature),
    !is.na(Growth_Days)
  )


# ---------------------------------------------------------
# 6. Sort & Group for Time-Based Calculations
# ---------------------------------------------------------
lettuce <- lettuce %>%
  group_by(Plant_ID) %>%
  arrange(Date, .by_group = TRUE)


# ---------------------------------------------------------
# 7. Engineer Daily Change Features
# ---------------------------------------------------------
lettuce <- lettuce %>%
  mutate(
    Temp_Change     = Temperature - lag(Temperature),  # Δ Temperature
    Humidity_Change = Humidity - lag(Humidity),        # Δ Humidity
    pH_Change       = pH - lag(pH),                    # Δ pH
    TDS_Change      = TDS_ppm - lag(TDS_ppm)           # Δ TDS
  )


# ---------------------------------------------------------
# 8. Rolling Averages (3-Day Window)
# ---------------------------------------------------------
lettuce <- lettuce %>%
  mutate(
    Temp_Roll3     = rollmean(Temperature, k = 3, fill = NA, align = "right"),
    Humidity_Roll3 = rollmean(Humidity,    k = 3, fill = NA, align = "right"),
    pH_Roll3       = rollmean(pH,          k = 3, fill = NA, align = "right"),
    TDS_Roll3      = rollmean(TDS_ppm,     k = 3, fill = NA, align = "right")
  )


# ---------------------------------------------------------
# 9. Optimal Range Flags
# ---------------------------------------------------------
lettuce <- lettuce %>%
  mutate(
    Temp_Optimal     = Temperature >= 18  & Temperature <= 24,
    Humidity_Optimal = Humidity    >= 50  & Humidity    <= 70,
    pH_Optimal       = pH          >= 5.5 & pH          <= 6.5,
    TDS_Optimal      = TDS_ppm     >= 800 & TDS_ppm     <= 1200
  )


# ---------------------------------------------------------
# 10. Composite Environmental Health Score
# ---------------------------------------------------------
lettuce <- lettuce %>%
  mutate(
    Temp_Optimal_num     = as.numeric(Temp_Optimal),
    Humidity_Optimal_num = as.numeric(Humidity_Optimal),
    pH_Optimal_num       = as.numeric(pH_Optimal),
    TDS_Optimal_num      = as.numeric(TDS_Optimal),
    Env_Score = (
      Temp_Optimal_num +
      Humidity_Optimal_num +
      pH_Optimal_num +
      TDS_Optimal_num
    ) / 4
  )

# Dataset expanded from 7 original variables to 24 engineered variables.


# ---------------------------------------------------------
# 11. Ungroup & Export
# ---------------------------------------------------------
lettuce <- lettuce %>%
  ungroup()

# Save cleaned dataset for Tableau or further analysis
write_csv(lettuce, "lettuce_cleaned_for_analysis.csv")
