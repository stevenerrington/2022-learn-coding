# Generalised linear model tutorial
# https://www.guru99.com/r-generalized-linear-model.html

# Load libraries
library(dplyr)
library(ggplot2)

# Read data from online source
data_adult <-read.csv("https://raw.githubusercontent.com/guru99-edu/R-Programming/master/adult.csv")

# Ceeck data
glimpse(data_adult)


continuous <-select_if(data_adult, is.numeric)
summary(continuous)

# Histogram with kernel density curve
ggplot(continuous, aes(x = hours.per.week)) +
  geom_density(alpha = .2, fill = "#FF6666")

top_one_percent <- quantile(data_adult$hours.per.week, .99)
top_one_percent