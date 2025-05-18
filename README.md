# IBM Bike Sharing Systems and Weather Data Integration Project

This project combines **web scraping**, **weather API interaction**, and **data preprocessing** in R to support exploratory analysis and modeling of bike sharing demand across global cities. The aim is to build predictive models that can accurately estimate the number of bikes rented under various weather conditions and temporal factors.

---
### Data Sources

- Seoul Bike Sharing Dataset: [UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets/Seoul+Bike+Sharing+Demand)
- World Cities: [Simplemaps](https://simplemaps.com/data/world-cities)
- OpenWeatherMap API: [https://openweathermap.org/api](https://openweathermap.org/api)

---

## Project Workflow

 **Data Collection**:
   - Scrapes Wikipedia for a list of bike sharing systems.
   - Uses OpenWeatherMap API to get current and forecast weather.

 **Data Cleaning & Feature Engineering**:
   - Converts variables to appropriate formats.
   - Normalizes numerical variables.
   - Creates dummy variables for categorical predictors.
   - Explores polynomial and interaction terms.

 **Modeling**:
   - Performs OLS regression.
   - Compares models using AIC, VIF, adjusted R², and residual diagnostics.

 **Evaluation**:
   - Visualizes residuals, correlations, and prediction performance.
   - Calculates RMSE and MAE for performance measurement.

---

## Requirements

- R (≥ 4.0)
- R packages:
  - `httr`, `jsonlite`, `rvest`, `dplyr`, `stringr`, `readr`, `lubridate`, `tidyr`, `fastDummies`

Install packages using:

install.packages(c("httr", "jsonlite", "rvest", "dplyr", "stringr", "readr", "lubridate", "tidyr", "fastDummies"))


source("scripts/data_pipeline.R")

---

## Results

- The final model aims to minimize RMSE and maximize interpretability.
- Key predictors include weather variables (temperature, humidity, etc.), time factors (hour, day, month), and engineered interactions.

---
## Future Enhancements

- Incorporate real-time streaming weather data.
- Extend to time series or machine learning models (e.g., XGBoost, LSTM).
- Deploy as an interactive Shiny dashboard.

---

## API Usage

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
