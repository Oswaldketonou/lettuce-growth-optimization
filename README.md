# 🌱 Lettuce Growth Optimization  
**Exploratory Data Analysis using R, tidyverse, and ggplot2**

This project analyzes controlled‑environment lettuce growth data to identify the environmental factors that most influence plant height and biomass.
The objective is to demonstrate a clear, end‑to‑end analytical workflow and deliver insights that support operational decision‑making in indoor agriculture.

---

## 📘 Executive Summary  
Indoor agriculture depends on precise environmental control to maximize yield. This analysis evaluates how temperature, humidity, watering frequency, and light exposure affect lettuce growth.
Using R and tidyverse, the dataset was cleaned, validated, and explored through a structured EDA process.

The findings highlight the strongest drivers of growth performance and provide evidence‑based recommendations that can help growers improve consistency, reduce waste, and optimize resource use.

---

## 📂 Repository Structure    
├── data/                 # Raw and cleaned datasets
├── scripts/              # R scripts for cleaning, EDA, and visualization
├── docs/                 # Narrative PDF and supporting documentation
├── visuals/              # Plots generated during EDA
└── README.md             # Project overview and insights

---

## 🧹 Data Preparation  
A reproducible cleaning workflow ensured the dataset was accurate and analysis‑ready:

- Removed missing, duplicated, and inconsistent values  
- Standardized units and variable names  
- Converted categorical variables into factors  
- Engineered features such as growth rate and temperature ranges  
- Validated assumptions and checked for outliers  

All steps are documented in the **EDA Narrative PDF**.

---

## 🔍 Exploratory Data Analysis  
The EDA focused on understanding how environmental variables influence growth outcomes. Key components included:

- Distribution analysis for height and biomass  
- Temperature and humidity impact assessment  
- Light exposure thresholds and diminishing returns  
- Interaction effects between temperature and watering frequency  
- Correlation analysis across numeric variables  
- Visualizations created with ggplot2  

Supporting plots are available in the `visuals/` directory.

---

## 📈 Key Findings  

### 🌡️ Temperature  
- The strongest predictor of growth performance  
- Optimal growth occurred within a defined mid‑range temperature band  
- Both low and high extremes reduced height and biomass  

### 💡 Light Exposure  
- Growth improved with increased light up to a saturation point  
- Additional exposure beyond that point produced minimal benefit  

### 💧 Watering Frequency  
- Watering interacted with temperature  
- Overwatering at higher temperatures negatively affected growth  

### 💨 Humidity  
- Moderate humidity supported more consistent biomass development  
- Large fluctuations reduced uniformity  

---

## 🧭 Recommendations  
Based on the analysis:

- Maintain temperature within the identified optimal range  
- Avoid excessive light exposure beyond the saturation threshold  
- Adjust watering frequency based on temperature conditions  
- Keep humidity stable within the moderate target band  

These recommendations support improved yield, reduced waste, and more predictable growth cycles.

---

## 📄 Full Analysis  
A complete narrative, including methodology, visuals, and interpretation, is available here:  
**`docs/lettuce_growth_EDA_narrative.pdf`**

---

## 🔧 Tools & Technologies  
| Category | Tools |
|---------|-------|
| Programming | R, tidyverse |
| Visualization | ggplot2 |
| Documentation | RMarkdown |
| Version Control | Git & GitHub |

---

## 🚀 Future Enhancements  
- Develop a predictive model for growth rate  
- Add time‑series analysis if temporal data becomes available  
- Build a Shiny dashboard for interactive exploration  
- Incorporate cost‑efficiency metrics for operational decision‑making  

---

## 👤 About the Analyst  
Business/Data Analyst with extensive operational leadership experience and a focus on transforming raw data into clear, actionable insights. Skilled in R, SQL, Python, and dashboard development, with a strong emphasis on data storytelling and practical decision support.
