# lettuce-growth-optimization
Data analysis and environmental optimization for lettuce growth in controlled agriculture
# 🌱 Lettuce Growth Optimization: Environmental Drivers & EDA Narrative

## 📌 Project Overview
This project explores how environmental conditions influence lettuce growth, using a structured data‑analysis workflow that moves from raw data → cleaning → feature engineering → exploratory data analysis (EDA) → insights.  
The goal is to identify which environmental factors most strongly affect growth days and to present the findings in a clear, reproducible, and portfolio‑ready format.

This repository includes:
- A fully commented R script for EDA  
- A feature‑engineering and cleaning pipeline  
- Cleaned datasets ready for analysis or dashboarding  
- A narrative PDF summarizing the EDA in plain language  
- Supporting summary statistics  

---

## 📂 Repository Structure

---

## 🧪 Dataset Description
The dataset contains environmental measurements and growth outcomes for lettuce plants. Key variables include:

- Temperature metrics (min, max, avg)  
- Humidity  
- Light exposure  
- Watering frequency  
- Growth days (target variable)  

The raw data required cleaning, type correction, and feature engineering before analysis.

---

## 🔧 Workflow Summary

### 1. Data Cleaning & Feature Engineering
Performed in the file:  
`lettuce_cleaning_engineering_pipeline`

Tasks included:
- Handling missing values  
- Converting data types  
- Creating engineered features (e.g., temperature ranges, normalized humidity)  
- Exporting a clean dataset for analysis  

---

### 2. Exploratory Data Analysis (EDA)
Performed in:  
`lettuce_exploratory_data_analysis.R`

The script includes:
- Summary statistics  
- Distribution checks  
- Correlation analysis  
- Visual exploration of environmental drivers  
- Export of summary tables  

A polished narrative of the EDA is available in:  
**`lettuce_eda_narrative.pdf`**

---

## 📊 Key Insights
A few high‑level findings from the analysis:

- Certain environmental variables show strong correlation with growth days.  
- Temperature variability appears to influence growth more than absolute temperature.  
- Humidity and light exposure interact in ways that affect growth efficiency.  
- Feature engineering improved interpretability and model‑readiness of the dataset.  

(See the narrative PDF for full explanations.)

---

## 🔁 Reproducibility

To reproduce the analysis:

1. Clone the repository  
2. Open `lettuce_environmental_analysis.Rproj` in RStudio  
3. Run the cleaning pipeline  
4. Run the EDA script  
5. Review outputs in the `/data` and `/docs` folders  

---

## 🛠 Tools & Technologies
- R (tidyverse, ggplot2, dplyr)  
- RStudio  
- CSV-based data workflows  
- Tableau (optional for dashboarding)  

---

## 🚀 Future Enhancements
- Build a predictive model for growth days  
- Add a Tableau dashboard to visualize environmental impacts  
- Expand feature engineering for more nuanced environmental metrics  
- Automate the pipeline with R Markdown or targets  
