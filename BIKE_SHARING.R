#Extract bike sharing systems systems from a Wiki page and convert it into a data frame
install.packages("tidyverse")
library(tidyverse)
install.packages("rvest")
library(rvest)

#WEB SCRAPPING

url <- "https://en.wikipedia.org/wiki/List_of_bicycle-sharing_systems"
# Get the root HTML node by calling the `read_html()` method with URL
html_root <- read_html(url)
print(html_root)
table_nodes <- html_node(html_root, "table")
print(table_nodes)
bike_sharing_df<-html_table(table_nodes,fill=TRUE)
glimpse(bike_sharing_df)

#Drop the second duplicate Country column by position and create a new data frame
new_bike_sharing_df <- bike_sharing_df[, !duplicated(names(bike_sharing_df))]
colnames(new_bike_sharing_df)
#Rename the column city/region to city
new_bike_sharing_df<-new_bike_sharing_df%>%rename(City = `City / Region`)
glimpse(new_bike_sharing_df)
summary(new_bike_sharing_df)

#Export and save the dataset
write.csv(new_bike_sharing_df, "raw_bike_sharing_systems.csv",row.names = FALSE)
raw_bike_sharing_systems<-read.csv("raw_bike_sharing_systems.csv")
glimpse(raw_bike_sharing_systems)
install.packages("httr")
library(httr)
current_weather_url <- 'https://api.openweathermap.org/data/2.5/weather'
my_api_key <- "8f1b4437fcff0732e16779424a478620"
current_query <- list(q = "Seoul", appid = my_api_key, units="metric")
response <- GET(current_weather_url, query=current_query)
http_type(response)
json_result <- content(response, as="parsed")
class(json_result)
print(json_result)
# Create some empty vectors to hold data temporarily
weather <- c()
visibility <- c()
temp <- c()
temp_min <- c()
temp_max <- c()
pressure <- c()
humidity <- c()
wind_speed <- c()
wind_deg <- c()
# $weather is also a list with one element, its $main element indicates the weather status such as clear or rain
weather <- c(weather, json_result$weather[[1]]$main)
# Get Visibility
visibility <- c(visibility, json_result$visibility)
# Get current temperature 
temp <- c(temp, json_result$main$temp)
# Get min temperature 
temp_min <- c(temp_min, json_result$main$temp_min)
# Get max temperature 
temp_max <- c(temp_max, json_result$main$temp_max)
# Get pressure
pressure <- c(pressure, json_result$main$pressure)
# Get humidity
humidity <- c(humidity, json_result$main$humidity)
# Get wind speed
wind_speed <- c(wind_speed, json_result$wind$speed)
# Get wind direction
wind_deg <- c(wind_deg, json_result$wind$deg)

# Combine all vectors
weather_data_frame <- data.frame(weather=weather, 
                                 visibility=visibility, 
                                 temp=temp, 
                                 temp_min=temp_min, 
                                 temp_max=temp_max, 
                                 pressure=pressure, 
                                 humidity=humidity, 
                                 wind_speed=wind_speed, 
                                 wind_deg=wind_deg)
# Check the generated data frame
print(weather_data_frame)


# Create some empty vectors to hold data temporarily
# City name column
city <- c()
# Weather column, rainy or cloudy, etc
weather <- c()
# Sky visibility column
visibility <- c()
# Current temperature column
temp <- c()
# Max temperature column
temp_min <- c()
# Min temperature column
temp_max <- c()
# Pressure column
pressure <- c()
# Humidity column
humidity <- c()
# Wind speed column
wind_speed <- c()
# Wind direction column
wind_deg <- c()
# Forecast timestamp
forecast_datetime <- c()
# Season column
# Note that for season, you can hard code a season value from levels Spring, Summer, Autumn, and Winter based on your current month.
season <- c()

# Get forecast data for a given city list
get_weather_forecast_by_cities <- function(city_names) {
  # Initialize empty data frame with the expected columns
  df <- data.frame(
    city = character(),
    date_time = character(),
    temp = numeric(),
    humidity = numeric(),
    description = character(),
    stringsAsFactors = FALSE
  )
  
  for (city_name in city_names) {
    # Forecast API URL
    forecast_url <- 'https://api.openweathermap.org/data/2.5/forecast'
    
    # Create query parameters
    forecast_query <- list(q = city_name, appid = my_api_key, units = "metric")
    
    # Make HTTP GET call for the given city
    response <- GET(forecast_url, query = forecast_query)
    
    # Check if request was successful
    if (status_code(response) == 200) {
      json_list <- content(response, "parsed")
      results <- json_list$list
      
      # Loop through each forecast entry
      for (result in results) {
        # Extract relevant data
        new_row <- data.frame(
          city = city_name,
          date_time = result$dt_txt,
          temp = result$main$temp,
          humidity = result$main$humidity,
          description = result$weather[[1]]$description,
          stringsAsFactors = FALSE
        )
        
        # Append to the data frame
        df <- rbind(df, new_row)
      }
    } else {
      warning(paste("Failed to get data for", city_name, "HTTP status:", status_code(response)))
    }
  }
  
  return(df)
}

# Set your API key (replace with your actual key)
my_api_key <- "8f1b4437fcff0732e16779424a478620"

# Load required library
library(httr)

# List of cities to query
cities <- c("Seoul", "Washington, D.C.", "Paris", "Suzhou")

# Call the function (note the parentheses to actually call it)
cities_weather_df <- get_weather_forecast_by_cities(cities)

# Write to CSV
write.csv(cities_weather_df, "cities_weather_forecast.csv", row.names = FALSE)
glimpse
# Download several datasets

# Download some general city information such as name and locations
url <- "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMDeveloperSkillsNetwork-RP0321EN-SkillsNetwork/labs/datasets/raw_worldcities.csv"
# download the file
download.file(url, destfile = "raw_worldcities.csv")

# Download a specific hourly Seoul bike sharing demand dataset
url <- "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMDeveloperSkillsNetwork-RP0321EN-SkillsNetwork/labs/datasets/raw_seoul_bike_sharing.csv"
# download the file
download.file(url, destfile = "raw_seoul_bike_sharing.csv")


dataset_list <- c('raw_bike_sharing_systems.csv', 'raw_seoul_bike_sharing.csv', 'cities_weather_forecast.csv', 'raw_worldcities.csv')

for (dataset_name in dataset_list){
  # Read dataset
  dataset <- read_csv(dataset_name)
  # Standardized its columns:
  # Convert all columns names to uppercase
  names(dataset) <- toupper(names(dataset))
  # Replace any white space separators by underscore, using str_replace_all function
  names(dataset) <- str_replace_all(names(dataset), " ", "_")
  # Save the dataset back
  write.csv(dataset, dataset_name, row.names=FALSE)
}

for (dataset_name in dataset_list){
  summary(dataset)
}


#PROCESS THE WEB SCRAPED BIKE SHARING SYSTEM DATASET
# First load the dataset
bike_sharing_df <- read_csv("raw_bike_sharing_systems.csv")
#Print its head
head(bike_sharing_df)

# Select the three columns
bike_sharing_df <- bike_sharing_df %>% select(COUNTRY, CITY, SYSTEM)

bike_sharing_df %>% 
  summarize_all(class) %>%
  gather(variable, class)

# Define a 'reference link' character class, 
# `[A-z0-9]` means at least one character 
# `\\[` and `\\]` means the character is wrapped by [], such as for [12] or [abc]
ref_pattern <- "\\[[A-z0-9]+\\]"
find_reference_pattern <- function(strings) grepl(ref_pattern, strings)

#Check whether the COUNTRY column has any reference links
bike_sharing_systems %>%
  filter(find_reference_pattern(COUNTRY)) %>%
  dplyr::select(COUNTRY) %>%
  slice(1:10)

#check whether the CITY column has any reference links
bike_sharing_systems %>%
  filter(find_reference_pattern(CITY)) %>%
  dplyr::select(CITY) %>%
  slice(1:10)

#check whether the SYSTEMS column has any reference links
bike_sharing_systems %>%
  filter(find_reference_pattern(SYSTEM)) %>%
  dplyr::select(SYSTEM) %>%
  slice(1:10)

#Remove undesired reference links using regular expressions
remove_ref <- function(strings) {
  ref_pattern <- "\\[\\d+\\]"  # Matches [number] patterns
  result <- str_replace_all(strings, ref_pattern, "") # Replace with empty string
  result <- str_trim(result)  # Optional: remove leading/trailing whitespace
  return(result)
}
# Apply the function to the CITY, SYSTEM and COUNTRY columns
bike_sharing_df <- bike_sharing_df %>%
  mutate(
    CITY = remove_ref(CITY),
    SYSTEM = remove_ref(SYSTEM),
    COUNTRY = remove_ref(COUNTRY)
  )
#checking whether all reference links have been removed
bike_sharing_systems %>% 
  dplyr::select(CITY, SYSTEM, COUNTRY) %>% 
  filter(find_reference_pattern(CITY) | find_reference_pattern(SYSTEM) | find_reference_pattern(COUNTRY))

write.csv(bike_sharing_df,"web_scrapped_clean_bike_sharing_systems.csv")

#DATA WRANGLING WITH DPLYR(ON raw_seoul_bike_sharing_csv)
seoul_bike_sharing_df <- read_csv("raw_seoul_bike_sharing.csv")
#a quick look at the dataset
summary(seoul_bike_sharing_df)
dim(seoul_bike_sharing_df)
#drop rows with missing values in the RENTED_BIKE_COUNT column
seoul_bike_sharing_df <- seoul_bike_sharing_df %>% filter(!is.na(RENTED_BIKE_COUNT))
#print dataset dimension after rows have been dropped
dim(seoul_bike_sharing_df)
#a look at the missing values in TEMPERATURE
seoul_bike_sharing_df %>% filter(is.na(TEMPERATURE))
print(unique(seoul_bike_sharing_df$SEASONS))
#It seems that all of the missing values for TEMPERATURE are found in SEASONS == Summer, so it is reasonable to impute those missing values with the summer average temperature
#calculating mean summer temperature
mean_summer_temperature <- seoul_bike_sharing_df %>%
  filter( SEASONS == "Summer") %>%
  summarise(mean_temp = mean(TEMPERATURE, na.rm = TRUE)) %>%
  pull(mean_temp)
print(mean_summer_temperature)
seoul_bike_sharing_df <- seoul_bike_sharing_df %>%
  mutate(
    TEMPERATURE = if_else(
      is.na(TEMPERATURE) & SEASONS == "Summer",
      mean(TEMPERATURE[SEASONS == "Summer"], na.rm = TRUE),
      TEMPERATURE
    )
  )
#print the dataset again to confirm no missing values
summary(seoul_bike_sharing_df)
# Save the dataset as `seoul_bike_sharing.csv`
write.csv(seoul_bike_sharing_df,"seoul_bike_sharing.csv")
glimpse(seoul_bike_sharing_df)
#Create indicator(dummy) variables for categorical variables
#Regression models can not process categorical variables directly, thus we need to convert them into indicator variables.
#In the bike-sharing demand dataset, SEASONS, HOLIDAY, FUNCTIONING_DAY are categorical variables. Also, HOUR is read as a numerical variable but it is in fact a categorical variable with levels ranged from 0 to 23.
seoul_bike_sharing_df <- seoul_bike_sharing_df %>%mutate(HOUR = as.character(HOUR))
#Convert SEASONS, HOLIDAY, FUNCTIONING_DAY, and HOUR columns into indicator columns.
install.packages("fastDummies")
library(fastDummies)
seoul_bike_sharing_df$SEASONS <- ifelse(seoul_bike_sharing_df$SEASONS == "Summer", 1, 0)
seoul_bike_sharing_df$HOLIDAY <- ifelse(seoul_bike_sharing_df$HOLIDAY == "Yes Holiday", 1, 0)
seoul_bike_sharing_df$HOUR<- ifelse(seoul_bike_sharing_df$HOUR == "0", 1, 0)
# Print the dataset summary again to make sure the indicator columns are created properly
summary(seoul_bike_sharing_df)
# Save the dataset as `seoul_bike_sharing_converted.csv`
write_csv(seoul_bike_sharing_df, "seoul_bike_sharing_converted.csv")

#Normalize Data(RENTED_BIKE_COUNT,TEMPERATURE,HUMIDITY,WIND_SPEED,VISIBILITY,DEW_POINT_TEMPERATURE,SOLAR_RADIATION,RAINFALL,SNOWFALL)
#Columns with large values may adversely influence (bias) the predictive models and degrade model accuracy. Thus, we need to perform normalization on these numeric columns to transfer them into a similar range.
seoul_bike_sharing_df <- seoul_bike_sharing_df %>%
  mutate(
    RENTED_BIKE_COUNT = (RENTED_BIKE_COUNT - min(RENTED_BIKE_COUNT, na.rm = TRUE)) / 
      (max(RENTED_BIKE_COUNT, na.rm = TRUE) - min(RENTED_BIKE_COUNT, na.rm = TRUE))
  )

seoul_bike_sharing_df <- seoul_bike_sharing_df %>%
  mutate(
    TEMPERATURE = (TEMPERATURE - min(TEMPERATURE, na.rm = TRUE)) / 
      (max(TEMPERATURE, na.rm = TRUE) - min(TEMPERATURE, na.rm = TRUE))
  )

seoul_bike_sharing_df <- seoul_bike_sharing_df %>%
  mutate(
    HUMIDITY= (HUMIDITY - min(HUMIDITY, na.rm = TRUE)) / 
      (max(HUMIDITY, na.rm = TRUE) - min(HUMIDITY, na.rm = TRUE))
  )

seoul_bike_sharing_df <- seoul_bike_sharing_df %>%
  mutate(
    WIND_SPEED = (WIND_SPEED - min(WIND_SPEED, na.rm = TRUE)) / 
      (max(WIND_SPEED, na.rm = TRUE) - min(WIND_SPEED, na.rm = TRUE))
  )

seoul_bike_sharing_df <- seoul_bike_sharing_df %>%
  mutate(
    VISIBILITY = (VISIBILITY - min(VISIBILITY, na.rm = TRUE)) / 
      (max(VISIBILITY, na.rm = TRUE) - min(VISIBILITY, na.rm = TRUE))
  )

seoul_bike_sharing_df <- seoul_bike_sharing_df %>%
  mutate(
    DEW_POINT_TEMPERATURE= (DEW_POINT_TEMPERATURE - min(DEW_POINT_TEMPERATURE, na.rm = TRUE)) / 
      (max(DEW_POINT_TEMPERATURE, na.rm = TRUE) - min(DEW_POINT_TEMPERATURE, na.rm = TRUE))
  )

seoul_bike_sharing_df <- seoul_bike_sharing_df %>%
  mutate(
    SOLAR_RADIATION= (SOLAR_RADIATION - min(SOLAR_RADIATION, na.rm = TRUE)) / 
      (max(SOLAR_RADIATION, na.rm = TRUE) - min(SOLAR_RADIATION, na.rm = TRUE))
  )

seoul_bike_sharing_df <- seoul_bike_sharing_df %>%
  mutate(
    RAINFALL= (RAINFALL - min(RAINFALL, na.rm = TRUE)) / 
      (max(RAINFALL, na.rm = TRUE) - min(RAINFALL, na.rm = TRUE))
  )

seoul_bike_sharing_df <- seoul_bike_sharing_df %>%
  mutate(
    SNOWFALL = (SNOWFALL - min(SNOWFALL, na.rm = TRUE)) / 
      (max(SNOWFALL, na.rm = TRUE) - min(SNOWFALL, na.rm = TRUE))
  )

#Print the summary of the dataset again to make sure the numeric columns range between 0 and 1
summary(seoul_bike_sharing_df)
# Save the dataset as `seoul_bike_sharing_converted_normalized.csv`
write_csv(seoul_bike_sharing_df, "seoul_bike_sharing_converted_normalized.csv")

#EXPLORATORY DATA ANALYSIS WITH SQL
install.packages("RSQLite")
library(RSQLite)
con <- dbConnect(SQLite(), dbname = "my_database.sqlite")
seoul_bike_sharing_df<-read.csv("seoul_bike_sharing.csv")
bike_sharing_df<-read.csv("bike_sharing_systems.csv")
cities_weather_df<-read.csv("cities_weather_forecast.csv")
cities_df<-read.csv("world_cities.csv")
dbWriteTable(con,"seoul_bike_sharing_df",seoul_bike_sharing_df)
dbWriteTable(con,"bike_sharing_df",bike_sharing_df)
dbWriteTable(con,"cities_weather_df",cities_weather_df)
dbWriteTable(con,"cities_df",cities_df)

#Determine how many records are in the seoul_bike_sharing dataset
results<-dbGetQuery(con,"SELECT COUNT(*) AS Records_in_seoul_bike_sharing_dataset
                             FROM SEOUL_BIKE_SHARING_DF")
print(results)

#Determine how many hours had non-zero rented bike count
results<-dbGetQuery(con,"SELECT COUNT(HOUR) AS NON_ZERO_RENTED_BIKE_COUNT
                             FROM SEOUL_BIKE_SHARING_DF
                                WHERE RENTED_BIKE_COUNT > 0")
print(results)

#Query the weather forecast for seoul over the next three hours
results<-dbGetQuery(con,"SELECT *
                             FROM CITIES_WEATHER_DF
                                WHERE CITY = 'Seoul'
                                    LIMIT 1")
print(results)

#seasons in the seoul_bike_sharing dataset
results<-dbGetQuery(con,"SELECT DISTINCT(SEASONS)
                            FROM SEOUL_BIKE_SHARING_DF")
print(results)

#Find the first and last dates in the seoul_bike_sharing dataset
results<-dbGetQuery(con,"SELECT MAX(DATE) AS FIRST_DATE, MIN(DATE) AS LAST_DATE
                             FROM SEOUL_BIKE_SHARING_DF")
print(results)

#Determine through a subquery which date and hour had the most bike rentals
query<-"SELECT RENTED_BIKE_COUNT,DATE, HOUR 
                   FROM SEOUL_BIKE_SHARING_DF
                     WHERE RENTED_BIKE_COUNT = (SELECT MAX(RENTED_BIKE_COUNT)
                             FROM SEOUL_BIKE_SHARING_DF)"
results<-dbGetQuery(con,query)
print(results)

#Determine the average hourly temperature and the average number of bike rentals per hour over each season. List the top ten results by average bike count
results<-dbGetQuery(con, "SELECT SEASONS,
                                   HOUR,
                                      AVG(TEMPERATURE) AS AVG_HOURLY_TEMPERATURE,
                                         AVG(RENTED_BIKE_COUNT) AS AVG_RENTED_BIKE_COUNT
                                             FROM SEOUL_BIKE_SHARING_DF
                                                GROUP BY HOUR,TEMPERATURE,SEASONS
                                                  ORDER BY AVG_RENTED_BIKE_COUNT
                                                      LIMIT 10")
print(results)

#Find the average hourly bike count during each season.Also include the minimum, maximum, and standard deviation of the hourly bike count for each season.
results<-dbGetQuery(con,"SELECT HOUR,SEASONS,
                                  AVG(RENTED_BIKE_COUNT) AS AVG_RENTED_BIKE_COUNT,
                                    MAX(RENTED_BIKE_COUNT) AS MAX_RENTED_BIKE_COUNT,
                                       MIN(RENTED_BIKE_COUNT) AS MIN_RENTED_BIKE_COUNT,
                                         SQRT(AVG(RENTED_BIKE_COUNT * RENTED_BIKE_COUNT) - AVG(RENTED_BIKE_COUNT) * AVG(RENTED_BIKE_COUNT)) AS StdDev_Bike_Count
                                           FROM SEOUL_BIKE_SHARING_DF
                                    GROUP BY HOUR,SEASONS" )
print(results)

#Consider the weather over each season. On average, what were the TEMPERATURE, HUMIDITY, WIND_SPEED, VISIBILITY, DEW_POINT_TEMPERATURE, SOLAR_RADIATION, RAINFALL, and SNOWFALL per season?
results<-dbGetQuery(con,"SELECT SEASONS,AVG(TEMPERATURE) AS AVG_TEMPERATURE,
                                  AVG(HUMIDITY) AS AVG_HUMIDITY,
                                     AVG(WIND_SPEED) AS AVG_WIND_SPEED,
                                         AVG(VISIBILITY) AS AVG_VISIBILITY,
                                             AVG(DEW_POINT_TEMPERATURE) AS AVG_DEW_POINT_TEMPERATURE,
                                                  AVG(SOLAR_RADIATION) AS AVG_SOLAR_RADIATION,
                                                      AVG(RAINFALL) AS AVG_RAINFALL,
                                                         AVG(SNOWFALL) AS AVG_SNOWFALL
                                         FROM SEOUL_BIKE_SHARING_DF
                                             GROUP BY SEASONS")
print(results)

#Use an implicit join across the WORLD_CITIES and the BIKE_SHARING_SYSTEMS tables to determine the total number of bikes available in Seoul, plus the following city information about Seoul: CITY, COUNTRY, LAT, LON, POPULATION, in a single view
results<-dbGetQuery(con,"SELECT TOTAL(b.BICYCLES) AS total_number_of_bicycles_seoul,
                                 c.CITY,
                                  c.COUNTRY,
                                   c.LAT,
                                    c.LNG,
                                     c.POPULATION
                               FROM CITIES_DF c,
                                    BIKE_SHARING_DF b
                                 WHERE c.CITY = 'Seoul'")
print(results)

#Find all cities with total bike counts between 15000 and 20000. Return the city and country names, plus the coordinates (LAT, LNG), population, and number of bicycles for each city.
results<-dbGetQuery(con,"SELECT c.CITY,
                                 c.COUNTRY,
                                  c.LAT,
                                   c.LNG,
                                    c.POPULATION,
                                     SUM(b.BICYCLES) AS total_number_of_bicycles
                             FROM 
                                BIKE_SHARING_DF b
                              JOIN 
                                    CITIES_DF c ON b.CITY = c.CITY
                                  GROUP BY 
                                        c.COUNTRY, c.LAT, c.LNG, c.POPULATION
                                     HAVING SUM(b.BICYCLES) BETWEEN 15000 AND 20000")
print(results)
close(con)

#EXPLORATORY ANALYSIS WITH TIDYVERSE AND GGPLOT2
seoul_bike_sharing_df<-read.csv("seoul_bike_sharing_converted_normalized.csv")
glimpse(seoul_bike_sharing_df)
#Reading Date as character
typeof(seoul_bike_sharing_df$DATE)
#Recast Date as a date suing the format "%d/%m/%y"
seoul_bike_sharing_df$DATE <- as.Date(seoul_bike_sharing_df$DATE, format = "%d/%m/%Y")
#cast HOURS as categorical variable(coerce its level to be an ordered sequence)
seoul_bike_sharing_df$HOUR <- factor(seoul_bike_sharing_df$HOUR,levels = 0:23,ordered = TRUE)
#check the structure of the dataframe
str(seoul_bike_sharing_df)
glimpse(seoul_bike_sharing_df)
#check again for no missing values
sum(is.na(seoul_bike_sharing_df))
#DESCRIPTIVE STATISTICS
summary(seoul_bike_sharing_df)
#How many holidays are there?(Holiday)
sum(seoul_bike_sharing_df$HOLIDAY == "Holiday")
#How many holidays are not there?
sum(seoul_bike_sharing_df$HOLIDAY == "No Holiday")
#calculate the percentage of records that fall on Holiday
result<-round((408/8465)*100)
print(result)
#Given the observations for the "FUNCTIONING_DAY",how many record must there be
sum(seoul_bike_sharing_df$FUNCTIONING_DAY == "Yes")
#Group the data by SEASONS and use the SUMMARISE() function to calculate the season total rainfall and snowfall
seasonal_totals <- seoul_bike_sharing_df %>%
  group_by(SEASONS) %>%
  summarise(
    TOTAL_RAINFALL = sum(RAINFALL, na.rm = TRUE),
    TOTAL_SNOWFALL = sum(SNOWFALL, na.rm = TRUE)
  )
print(seasonal_totals)

#DATA VISUALIZATION
install.packages("ggplot2")
library(ggplot2)
#create a scatter plot of RENTED_BIKE_COUNT vs DATE
ggplot(data=seoul_bike_sharing_df,aes(y=RENTED_BIKE_COUNT,x=DATE))+
  geom_point(alpha=1,color="blue",size=1)+
   geom_smooth(method="loess")+
   labs(title="A scatter plot of RENTED_BIKE_COUNT VS DATE",
           y= "RENTED_BIKE_COUNT",
           x="DATE")+
   theme_minimal()

#create the same plot of the RENTED_BIKE_COUNT time series, but now add HOURS as the colour
ggplot(data=seoul_bike_sharing_df,aes(y=RENTED_BIKE_COUNT,x=DATE,color=as.factor(HOUR)))+
  geom_point(alpha=1,color="lightcoral",size=1)+
  geom_smooth(method="loess")+
  labs(title="A scatter plot of RENTED_BIKE_COUNT VS DATE(Colored by Hour)",
       y= "RENTED_BIKE_COUNT",
       x="DATE",
       color="Hour of day")+
  scale_color_viridis_d() +
  theme_minimal()

#create a histogram overlaid with a kernel density curve
ggplot(seoul_bike_sharing_df, aes(x = RENTED_BIKE_COUNT)) +
  geom_histogram(aes(y = ..density..), 
                 bins = 30, fill = "white", color = "black", alpha = 0.6) +
  geom_density(color = "red", size = 1.2) +
  labs(
    title = "Histogram with Kernel Density Curve",
    x = "Rented Bike Count",
    y = "Density"
  ) +
  theme_minimal()
#use a scatter plot to visualize the correlation between RENTED_BIKE_COUNT and TEMPERATURE by SEASONS
#start with RENTED_BIKE_COUNT vs. TEMPERATURE,then generate four plots corresponding to the SEASONS by adding a facet_wrap() layer.
#Also make use of color and opacity to emphasize any patterns that emerge. use HOUR as the color
ggplot(data=seoul_bike_sharing_df,aes(y=RENTED_BIKE_COUNT,x=TEMPERATURE,color=as.factor(HOUR)))+
  geom_point(alpha=2,color="purple",size=1)+
    labs(title="A scatter plot of RENTED_BIKE-COUNT vs. TEMPERATURE FACETED BY SEASONS",
         y="RENTED_BIKE_COUNT",
         x="TEMPERATURE FACETED BY SEASONS",
         color="HOUR of Day")+
  facet_wrap(~SEASONS)+
  theme_minimal()
#outliers(Boxplot)
#create a display of four boxplots of RENTED_BIKE_COUNT vs. HOUR grouped by SEASONS.use facet_wrap() to generate four plots corresponding to SEASONS
seoul_bike_sharing_df$HOUR <- as.factor(seoul_bike_sharing_df$HOUR)
ggplot(data=seoul_bike_sharing_df,aes(y=RENTED_BIKE_COUNT,x=HOUR))+
  geom_boxplot(fill = "peachpuff", outlier.color = "tomato", outlier.size = 1)+
  labs(title="A boxplot of RENTED_BIKE-COUNT vs. TEMPERATURE FACETED BY SEASONS",
       y="RENTED_BIKE_COUNT",
       x="HOUR")+
  facet_wrap(~SEASONS)+
  theme_minimal()
colors()
#Group the data by DATE, and use the summarize() function to calculate the daily total rainfall and snowfall
#Plot the results
grouped_by_date<-seoul_bike_sharing_df%>%
                      group_by(DATE)%>%
                         summarise(
                           TOTAL_RAINFALL=sum(RAINFALL,na.rm=TRUE),
                           TOTAL_SNOWFALL=sum(SNOWFALL,na.rm=TRUE)
                         )
print(grouped_by_date)
# Plot daily rainfall and snowfall
ggplot(data=grouped_by_date, aes(x = DATE)) +
  geom_line(aes(y = TOTAL_RAINFALL, color = "RAINFALL"), size = 1) +
  geom_line(aes(y = TOTAL_SNOWFALL, color = "SNOWFALL"), size = 1) +
  labs(
    title = "Daily Total Rainfall and Snowfall",
    x = "Date",
    y = "Precipitation (mm)",
    color = "Precipitation Type"
  ) +
  theme_minimal()
#Determine how many days had snowfall
days_with_snowfall<-grouped_by_date%>%
              filter(TOTAL_SNOWFALL>0,na.rm=TRUE)%>%nrow()
print(days_with_snowfall)

#REGRESSION ANALYSIS
#Predict bike sharing demand by using Regression models
#After performing exploratory and visual analysis on the bike sharing demand datasets and obtaining some preliminary insights on the attributes, it’s time to build, evaluate, and refine several predictive models and find the best performing model for predicting hourly bike rent count.
#For this analysis we will use the normalized dataset
seoul_bike_data_normalized_df<-read.csv("seoul_bike_sharing_converted_normalized.csv")
names(seoul_bike_data_normalized_df)
#we will not use the DATE and FUNCTIONING_DAY columns so remove them
library(dplyr)
seoul_bike_data_normalized_df <- subset(seoul_bike_data_normalized_df, 
                                        select = -c(DATE, FUNCTIONING_DAY))
glimpse(seoul_bike_data_normalized_df)
#Begin regression analysis by splitting the data,75 percent for training and 25 percent for testing
set.seed(1234)
n<-nrow(seoul_bike_data_normalized_df)
train_indices<-sample(1:n,size=0.75*n)#randomly select 75 percent of the data
train_set<-seoul_bike_data_normalized_df[train_indices, ] #training data
test_set<-seoul_bike_data_normalized_df[-train_indices, ] #testing data
view(train_set)
view(test_set)

#CORRELATION ANALYSIS
cor_matrix <- cor(train_set)
print(cor_matrix) #simply prints  correlation significance
install.packages("Hmisc") #For rcorr use, must install this package
library(Hmisc)
rcorr(as.matrix(train_set)) # prints correlation significance(-1,1) and the p-values(significant at p<0.05)

#First install all necessary packages 
library(tidymodels)
install.packages("yardstick")
library(yardstick)
install.packages("Metrics")
library(Metrics)
library(caret) #For cross validation
install.packages("MASS") #For Stepwise model selection based on Akaike Information Criterion
library(MASS)

#Build a linear regression model using weather variables ONLY
lm_model_weather_variables_only<-lm(RENTED_BIKE_COUNT~TEMPERATURE + HUMIDITY + WIND_SPEED + VISIBILITY + 
                        DEW_POINT_TEMPERATURE + SOLAR_RADIATION + RAINFALL + SNOWFALL , data=train_set)
summary(lm_model_weather_variables_only)
r_squared_model_weather<-summary(lm_model_weather_variables_only)$r.squared
adj_r_squared_model_weather<-summary(lm_model_weather_variables_only)$adj.r.squared
mse_model_weather <- mean(lm_model_weather_variables_only$residuals^2)
rmse_model_weather <- sqrt(mse_model_weather)
print(r_squared_model_weather)
print(adj_r_squared_model_weather)
print(mse_model_weather)
print(rmse_model_weather)

#Build a linear regression model using ALL variables
lm_model_all_variables<-lm(RENTED_BIKE_COUNT~TEMPERATURE + HUMIDITY + WIND_SPEED + VISIBILITY + 
                   DEW_POINT_TEMPERATURE + SOLAR_RADIATION + RAINFALL + SNOWFALL + SEASONS + HOLIDAY + HOUR , data = train_set)
summary(lm_model_all_variables)
r_squared_model_all<-summary(lm_model_all_variables)$r.squared
adj_r_squared_model_all<-summary(lm_model_all_variables)$adj.r.squared
mse_model_all<-mean(lm_model_all_variables$residual^2)
rmse_model_all<-sqrt(mse_model_all)
print(r_squared_model_all)
print(adj_r_squared_model_all)
print(mse_model_all)
print(rmse_model_all)
Adjusted_R_Squared<-c("0.4295","0.443")
mse<-c("0.0187","0.0183")
rmse<-c("0.1370","0.1353")
comparison_table<-data.frame(Adjusted_R_Squared,mse,rmse,row.names = c("model_weather","model_all"))
print(comparison_table)

#check by prediction how the models perform on the test_set
test_pred_1<-predict(lm_model_weather_variables_only,newdata = test_set)
test_pred_2<-predict(lm_model_all_variables, newdata = test_set)
# Create a results data frame with predictions and actual values (truth)
results_1<- data.frame(
  truth = test_set$RENTED_BIKE_COUNT,
  prediction = test_pred_1
)
head(results_1,10)
#Create a results dataframe with predictions and actual values (truth)
results_2 <- data.frame(
  truth = test_set$RENTED_BIKE_COUNT,
  prediction = test_pred_2
)
head(results_2,10)

coefficients<-data.frame(sort(lm_model_all$coefficients))
print(coefficients)
variables<-c("TEMPERATURE","SNOWFALL","WIND-SPEED","DEW_POINT_TEMPERATURE","VISIBILITY")
coefficients<-c(0.6697,0.118 , 0.114 , 0.015,0.014)
variable_coeffeicients_table<-data.frame(variables,coefficients)
print(variable_coeffeicients_table)
summary(lm_model_all)

ggplot(data=variable_coeffeicients_table, aes(y = reorder(variables,coefficients),x=coefficients))+
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(
    title = "Linear Model Coefficients",
    x = "Predictor",
    y = "Coefficient Estimate"
  ) +
  theme_minimal()

#calculate MSE and RMSE for the two models on the test set
#Predict on the test set
#the `newdata` equated to the test set is important
test_pred_1 <- predict(lm_model_weather_variables_only, newdata=test_set)
mse <- mean((test_set$RENTED_BIKE_COUNT - test_pred_1)^2)
print(paste("MSE:", mse))
rmse<-sqrt(mse)
print(paste("rmse:",rmse))

test_pred_2 <- predict(lm_model_all_variables, newdata=test_set)
mse <- mean((test_set$RENTED_BIKE_COUNT - test_pred_2)^2)
print(paste("MSE:", mse))
rmse<-sqrt(mse)
print(paste("rmse:",rmse))

#IMPROVING THE MODEL
#Polynomial regression
#I begin with simple linear regressions model to identify order polynomials to input later

#The loess curve assumes an S shape so a higher order 3 polynomial is recommended
ggplot(data=train_set, aes(x = TEMPERATURE, y = RENTED_BIKE_COUNT)) +
  geom_point() +
  geom_smooth(method = "loess", color = "antiquewhite") +
  geom_smooth(method = "lm", color = "antiquewhite4")+
  geom_smooth(method = "lm", formula = y ~ poly(x,3))

#The loess curve assumes a parabola shape so a higher order 2 polynomial is recommended
ggplot(data=train_set, aes(x = HUMIDITY, y = RENTED_BIKE_COUNT)) +
  geom_point() +
  geom_smooth(method = "loess", color = "aquamarine") +
  geom_smooth(method = "lm", color = "aquamarine4")+
  geom_smooth(method = "lm",  formula = y ~ poly(x, 2))

#The curve assumes a parabola shape so a higher order polynomial of order 2 is recommended
ggplot(data=train_set, aes(x = WIND_SPEED, y = RENTED_BIKE_COUNT)) +
  geom_point() +
  geom_smooth(method = "loess", color = "azure") +
  geom_smooth(method = "lm", color = "red")+
  geom_smooth(method = "lm" , formula = y ~ poly ( x , 2),color="azure4")

qqq

#The curve assumes an S shape so a higher order 3 polynomial is recommended
ggplot(data=train_set, aes(x = VISIBILITY, y = RENTED_BIKE_COUNT)) +
  geom_point() +
  geom_smooth(method = "loess", color = "blue") +
  geom_smooth(method = "lm", color = "red")+
  geom_smooth(method = "lm", formula = y ~ poly(x,3),color = "blue4")

#The curve assumes an S shape so a higher order 3 polynomial is recommended
ggplot(data=train_set, aes(x = DEW_POINT_TEMPERATURE, y = RENTED_BIKE_COUNT)) + 
  geom_point() + 
  geom_smooth(method="loess",color="brown")+
  geom_smooth(method = "lm", formula = y ~ x, color="red") + 
  geom_smooth(method = "lm", formula = y ~ poly(x, 3), color="brown4")

#The curve assumes a complex shape so a higher order 4+ polynomial is recommended
ggplot(data=train_set, aes(x = SOLAR_RADIATION, y = RENTED_BIKE_COUNT)) + 
  geom_point() + 
  geom_smooth(method="loess",color="ivory")+
  geom_smooth(method = "lm", formula = y ~ x, color="red") + 
  geom_smooth(method = "lm", formula = y ~ poly(x, 4), color="ivory4")

#The curve will assume a parabola shape so a higher order 2 polynomial is recommended
ggplot(data=train_set, aes(x = RAINFALL, y = RENTED_BIKE_COUNT)) +
  geom_point() +
  geom_smooth(method="loess",color="lightpink")
  geom_smooth(method = "lm", color = "red")+
  geom_smooth(method = "lm" , formula = y ~ poly(x,2),color= "lightpink4")


lm_poly <- lm(RENTED_BIKE_COUNT ~ 
                poly(TEMPERATURE, 3,raw = TRUE) + 
                poly(HUMIDITY, 2, raw = TRUE) + 
                poly(WIND_SPEED, 2, raw = TRUE) + 
                poly(SNOWFALL, 2, raw = TRUE) + 
                poly(RAINFALL, 2, raw = TRUE) +
                poly(SOLAR_RADIATION,4, raw = TRUE)+
                poly(DEW_POINT_TEMPERATURE, 3, raw = TRUE) + 
                poly(VISIBILITY, 3, raw = TRUE)+
                SEASONS +
                HOUR +
                HOLIDAY,
              data = train_set)
summary(lm_poly)
summary(lm_poly)$adj.r.squared
mse_lm_poly <- mean(lm_poly$residuals^2)
rmse_lm_poly <- sqrt(mse_lm_poly)
print(rmse_lm_poly)

#ADD_INTERACTION_TERMS
model_interaction_poly_1 <- lm(RENTED_BIKE_COUNT ~ 
                               poly(TEMPERATURE,3,raw=TRUE)*poly(HUMIDITY,2,raw=TRUE)+
                               poly(VISIBILITY,3,raw=TRUE)*poly(WIND_SPEED,2,raw=TRUE) +
                               poly(DEW_POINT_TEMPERATURE,3,raw=TRUE) +
                               poly(SOLAR_RADIATION,4,raw=TRUE)+
                               poly(RAINFALL,2,raw=TRUE) +
                               HOUR,
                             data = train_set)
summary(model_interaction_poly_1)$adj.r.squared
mse_model_interaction <- mean(model_interaction_poly_1$residuals^2)
rmse_model_interaction <- sqrt(mse_model_interaction)
print(rmse_model_interaction)

model_interaction_poly_2 <- lm(RENTED_BIKE_COUNT ~ 
                               poly(TEMPERATURE,3,raw=TRUE)*poly(HUMIDITY,2,raw=TRUE)+
                               poly(VISIBILITY,3,raw=TRUE)*poly(WIND_SPEED,2,raw=TRUE) +
                               poly(DEW_POINT_TEMPERATURE,3,raw=TRUE)*poly(TEMPERATURE,2,raw=TRUE) +
                               poly(SOLAR_RADIATION,4,raw=TRUE)*poly(TEMPERATURE,2,raw=TRUE) +
                               poly(RAINFALL,2,raw=TRUE)*poly(HUMIDITY,2,raw=TRUE) +
                               poly(WIND_SPEED,2,raw=TRUE)+
                               poly(TEMPERATURE,3,raw = TRUE)*HOUR,
                             data = train_set)
summary(model_interaction_poly_2)$adj.r.squared
mse_model_interaction <- mean(model_interaction_poly_2$residuals^2)
rmse_model_interaction <- sqrt(mse_model_interaction)
print(mse_model_interaction)
print(rmse_model_interaction)

model_interaction_poly_3 <- lm(RENTED_BIKE_COUNT ~ 
                               poly(TEMPERATURE,3,raw=TRUE)*poly(HUMIDITY,2,raw=TRUE) *poly(WIND_SPEED,2,raw=TRUE)+
                               poly(VISIBILITY,3,raw=TRUE)*poly(WIND_SPEED,2,raw=TRUE)*poly(TEMPERATURE,2, raw = TRUE)+
                               poly(DEW_POINT_TEMPERATURE,3,raw=TRUE)*poly(TEMPERATURE,2,raw=TRUE) +
                               poly(SOLAR_RADIATION,4,raw=TRUE)*poly(TEMPERATURE,2,raw=TRUE)+
                               poly(RAINFALL,2,raw=TRUE)*poly(HUMIDITY,2,raw=TRUE) +
                               poly(TEMPERATURE,3,raw = TRUE)*HOUR,
                               data = train_set)
summary(model_interaction_poly_3)$adj.r.squared
mse_model_interaction <- mean(model_interaction_poly_3$residuals^2)
rmse_model_interaction <- sqrt(mse_model_interaction)
print(rmse_model_interaction)

#a comparison table of polynomial regression and polynomial regression with adding interaction effects
Adjusted_R_Squared<-c("0.43","0.44","0.55","0.56","0.58","0.60")
Root_Mean_Squared_Error<-c("0.137","0.135","0.121","0.119","0.116","0.113")
comparison_table<-data.frame(Adjusted_R_Squared,Root_Mean_Squared_Error,
                             row.names = c("OLS_weather_only","OLS_all_variables","lm_poly","lm_poly_interaction_1","lm_poly_interaction_2","lm_poly_interaction_3"))
print(comparison_table)  #clearly the model has improved as a result of adding interaction effects

#A look at how our model_interaction performs on unseen data
model_interaction_test_set <- predict(lm_model_all_variables, newdata = test_set)
mse <- mean((test_set$RENTED_BIKE_COUNT - model_interaction_test_set)^2)
print(paste("MSE:", mse))
rmse<-sqrt(mse)
print(paste("rmse:",rmse))

#ADD REGULARIZATION
install.packages("glmnet")
library(glmnet)

#Define the formula with interactions and raw polynomials
poly_formula <- RENTED_BIKE_COUNT ~ 
  poly(TEMPERATURE,3,raw=TRUE)*poly(HUMIDITY,2,raw=TRUE) *poly(WIND_SPEED,2,raw=TRUE)+
  poly(VISIBILITY,3,raw=TRUE)*poly(WIND_SPEED,2,raw=TRUE)*poly(TEMPERATURE,2, raw = TRUE)+
  poly(DEW_POINT_TEMPERATURE,3,raw=TRUE)*poly(TEMPERATURE,2,raw=TRUE) +
  poly(SOLAR_RADIATION,4,raw=TRUE)*poly(TEMPERATURE,2,raw=TRUE)+
  poly(RAINFALL,2,raw=TRUE)*poly(HUMIDITY,2,raw=TRUE) +
  poly(TEMPERATURE,3,raw = TRUE)*HOUR

#Create model matrix and response for training
x_train <- model.matrix(poly_formula, data = train_set)[, -1]  # Remove intercept column
y_train <- train_set$RENTED_BIKE_COUNT

# Create model matrix and response for testing
x_test <- model.matrix(poly_formula, data = test_set)[, -1]  # Remove intercept column
y_test <- test_set$RENTED_BIKE_COUNT

# Elastic Net with cross-validation
cv_fit <- cv.glmnet(x_train, y_train,
                    alpha = 0.5,             # Elastic net mixing
                    family = "gaussian",     # For regression
                    nfolds = 10,              # 5-fold CV
                    )      # Standardize predictors

# Best lambda and final model
best_lambda <- cv_fit$lambda.min
final_model <- glmnet(x_train, y_train, alpha = 0.5, lambda = best_lambda)
#Predictions on training set
train_preds <- predict(final_model, newx = x_train)
rmse_train <- sqrt(mean((y_train - train_preds)^2))
rsq_train <- 1 - sum((y_train - train_preds)^2) / sum((y_train - mean(y_train))^2)
#Output training metrics
print(rmse_train)
print(rsq_train)
#Predictions on test set
test_preds <- predict(final_model, newx = x_test)
rmse_test <- sqrt(mean((y_test - test_preds)^2))
print(rmse_test)

#Visualizing different model performances as grouped bar charts
results <- data.frame(
  Model = c("OLS_weather_only", "OLS_all_variables","lm_poly", "lm_poly_interaction_1", "lm_poly_interaction_2","lm_poly_interaction_3"),
  RMSE = c(0.137, 0.135, 0.121, 0.119, 0.116, 0.113),
  R2 = c(0.43, 0.44, 0.55, 0.56,0.58,0.60)
)
results_long <- results %>%
  pivot_longer(cols = c("RMSE", "R2"), names_to = "Metric", values_to = "Value")
ggplot(results_long, aes(x = Model, y = Value, fill = Metric)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Model Performance Metrics", y = "Value") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  theme_minimal()

#Q-Q plot comparing the distributions
#A prediction on the test set as from above
predictions <- predict(final_model, newx = x_test)
# Actual values
actuals <- test_set$RENTED_BIKE_COUNT 
qq_data <- data.frame(
  truth = actuals,
  prediction = as.numeric(predictions)  # Ensure predictions is numeric
)
ggplot(qq_data) +
  stat_qq(aes(sample = truth), color = 'green') +
  stat_qq(aes(sample = prediction), color = 'red') +
  labs(title = "Q-Q Plot: Predictions vs Actuals",
       x = "Theoretical Quantiles", y = "Sample Quantiles") +
  theme_minimal()
