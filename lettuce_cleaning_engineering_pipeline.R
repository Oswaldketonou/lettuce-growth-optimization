# Loading packages for data manipulation and visualization
library(tidyverse)

#loading lubridate for working with dates(parsing, converting, etc)
library(lubridate)

#loading zoo for rolling calculations like moving averages
library(zoo)

# read the raw lettuce dataset from a xltx file in my working directory
# replace the file name with lettuce_raw
lettuce_raw <- readxl::read_xlsx("data/lettuce_dataset.xltx")

# Quick inspection of the structure of the raw data (column types, sample value)
summary(lettuce_raw)

# Creating a copy of the raw data to work on, keeping the original untouched
lettuce <- lettuce_raw


# Cleaning and standardizing columns: converting column date assuring we have yyyy-mm-d format

str(lettuce$Date)
summary(lettuce)

# Renaming columns to clearer, consistent names
lettuce <- lettuce %>%
  rename(
    Plant_ID     = Plant_ID,           # Unique identifier for each plant
    Temperature  = `Temperature (°C)`, # Temperature in Celsius
    Humidity     = `Humidity (%)`,     # Humidity ( may be fraction or percent)
    pH           = `pH Level` ,        # pH level
    TDS_ppm      = `TDS Value (ppm)`,  # Total dissolved solids in ppm
    Growth_Days  = `Growth Days`       # Days since planting / growth duration
  )
# If Humidity was store as a fraction (e.g , 0.65) then it will converted to percentage(65)
#Then this following code to convert will be applied (lettuce <- lettuce %>% mutate(Humidity = Humidity * 100)) but this not the case

# Checking for duplicate row in the dataset
lettuce %>%
  duplicated() %>%
  sum()        # this print the number of duplicate rows

# Removing any duplicate rows if the they exist
lettuce <- lettuce %>%
  distinct()

# Checking for how many missing values exist in each column
lettuce %>%
  summarise(across(everything(), ~ sum(is.na(.))))
# It show that there is not missing values in the data
# Optionally remove rows with missing critical fields (e.g. , Date, Temperature, Growth_days)
lettuce <- lettuce %>%
  filter(
    !is.na(Date),
    !is.na(Temperature),
    !is.na(Growth_Days)
  )
# Sorting the data by plant and date
# Group by plant and sort by date so that time-based calculations ( like lag and rolling averages)
lettuce <- lettuce %>%
  group_by(Plant_ID) %>%
  arrange(Date, .by_group = TRUE)

# Engineering daily change feature
# Create new columns that capture the day-to-day change in each environment variable
lettuce <- lettuce %>%
  mutate(
    Temp_Change     = Temperature - lag(Temperature),  # Change in temperature from previous day
    Humidity_Change = Humidity - lag(Humidity),        # Change in humidity from previous day
    pH_Change       = pH - lag(pH),                    # Change in pH from  previous day
    TDS_Change      = TDS_ppm - lag(TDS_ppm)           # Change in TDS from previous day
  )
# Engineer rolling averages (3-day window) 
# Add 3-day rolling averages for each environmental variable
# Align = "right" means the value at a given date uses that day and the previous 2 days
lettuce <- lettuce %>%
  mutate(
    Temp_Roll3     = rollmean(Temperature,   k = 3, fill = NA, align = "right"),
    Humidity_Roll3 = rollmean(Humidity,      k = 3, fill = NA, align = "right"),
    pH_Roll3       = rollmean(pH,            k = 3, fill = NA, align = "right"),
    TDS_Roll3      = rollmean(TDS_ppm,       k = 3, fill = NA, align = "right")
  )
# Creating Optimal range flags (initial assumptions)
# Create TRUE/FALSE flags indicating whether each variable is within an assumed optimal range
# these ranges can be refine later base on research or analysis
lettuce <- lettuce %>%
  mutate(
    Temp_Optimal      = Temperature >= 18  & Temperature <= 24,    # Example optimal temperature range
    Humidity_Optimal  = Humidity    >= 50  & Humidity    <= 70,    # Example optimal humidity range
    pH_Optimal        = pH          >= 5.5 & pH          <= 6.5,   # Example optimal pH range
    TDS_Optimal       = TDS_ppm     >= 800 & TDS_ppm     <= 1200   # Example optimal TDS range
  )

# Building a composite environmental health score
# Convert TRUE/FALSE optimal flags to numeric ( TRUE= 1, FALSE= 0)
# Then Compute the average across the four conditions to get a score between 0 and 1
lettuce <- lettuce %>%
  mutate(
    Temp_Optimal_num     = as.numeric(Temp_Optimal),
    Humidity_Optimal_num = as.numeric(Humidity_Optimal),
    pH_Optimal_num       = as.numeric(pH_Optimal),
    TDS_Optimal_num      = as.numeric(TDS_Optimal),
    Env_Score            = (Temp_Optimal_num +
                            Humidity_Optimal_num +
                            pH_Optimal_num +
                            TDS_Optimal_num) / 4
  )
# The data went from 7 initial variables to 24 final variables preparing for analysis
# Now lets remove grouping  so the dataset behaves like a regular data frame again
lettuce <- lettuce %>%
  ungroup()

# Save the clean and feature-engineered dataset to a new CSV file
#This file will be used later in Tableau or further analysis
write_csv(lettuce, "lettuce_cleaned_for_analysis.csv")
