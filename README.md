# 🚲 IBM Bike Sharing Systems & Weather Data Integration Project

This project combines **web scraping**, **weather API interaction**, and **data preprocessing** in R to support exploratory analysis and modeling of bike sharing demand across global cities. The aim is to build predictive models that can accurately estimate the number of bikes rented under various weather conditions and temporal factors.

---
### 📁 Data Sources

- Seoul Bike Sharing Dataset: [UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets/Seoul+Bike+Sharing+Demand)
- World Cities: [Simplemaps](https://simplemaps.com/data/world-cities)
- OpenWeatherMap API: [https://openweathermap.org/api](https://openweathermap.org/api)

## 🔍 Key Features

### 🌐 Web Scraping

- Scrapes [Wikipedia's list of bicycle sharing systems](https://en.wikipedia.org/wiki/List_of_bicycle-sharing_systems) to extract and clean data on cities with active programs.
- Removes inline citation references using regex.

### ☁️ Weather API Integration

- Retrieves **current weather** and **forecast data** using OpenWeatherMap for key cities.
- Supports batch querying and structured JSON parsing.

### 🧹 Data Cleaning & Wrangling

- Handles missing temperature values via seasonal means.
- Converts categorical columns to dummy variables (`SEASONS`, `HOLIDAY`, `FUNCTIONING_DAY`).
- Normalizes continuous variables for modeling purposes (0–1 scale).

---

## 🔧 Requirements

- R (≥ 4.0)
- R packages:
  - `httr`, `jsonlite`, `rvest`, `dplyr`, `stringr`, `readr`, `lubridate`, `tidyr`, `fastDummies`

Install packages using:

install.packages(c("httr", "jsonlite", "rvest", "dplyr", "stringr", "readr", "lubridate", "tidyr", "fastDummies"))


source("scripts/data_pipeline.R")

---

## 📈 Results

- The final model aims to minimize RMSE and maximize interpretability.
- Key predictors include weather variables (temperature, humidity, etc.), time factors (hour, day, month), and engineered interactions.

---
## 🚀 Future Enhancements

- Incorporate real-time streaming weather data.
- Extend to time series or machine learning models (e.g., XGBoost, LSTM).
- Deploy as an interactive Shiny dashboard.

---

## 🔑 API Usage

This project uses **OpenWeatherMap API** — ensure you have a valid API key. Replace `"your_api_key_here"` with your actual key in the script.

---

### How to run

* Clone the repository.

* Open the file in RStudio.

* Run line-by-line or as a full script.

Note: Required packages will be installed automatically if not already present.

---

### Author
Fortunatus Ochieng
Data Scientist | BSc Statistic

### License
This project is open-source and free to use under the MIT License.
