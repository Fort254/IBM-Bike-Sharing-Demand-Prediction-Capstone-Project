#IBM-Bike-Sharing-Demand-Prediction-Capstone-Project


---

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

### 📁 Data Sources

- Seoul Bike Sharing Dataset: [UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets/Seoul+Bike+Sharing+Demand)
- World Cities: [Simplemaps](https://simplemaps.com/data/world-cities)
- OpenWeatherMap API: [https://openweathermap.org/api](https://openweathermap.org/api)

---

## 🔧 Requirements

- R (≥ 4.0)
- R packages:
  - `httr`, `jsonlite`, `rvest`, `dplyr`, `stringr`, `readr`, `lubridate`, `tidyr`, `fastDummies`

Install packages using:

```r
install.packages(c("httr", "jsonlite", "rvest", "dplyr", "stringr", "readr", "lubridate", "tidyr", "fastDummies"))

