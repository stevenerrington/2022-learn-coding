# Learning R through the "R for Psychological Sciences" by Danielle Navarro tutorial

# Describing data
# https://psyr.djnavarro.net/describing-data.html

# Setup workspace
setwd("./r-psychsci/") # Project references ./learn-r/, so let's move it to our /r-psychsci dir for this script
library(tidyverse) 
library(magrittr)

# Load in AFL data from CSV file
afl <- read_csv("./data/afl.csv")

# Descriptive statistics #############################################
mean(afl$home_score) # Get mean home score from AFL dataframe
sd(afl$home_score) # Get SD home score from AFL dataframe
# Note: if there is a NaN or null value, then append the function with
# (, na.rm = TRUE) - i.e. mean(afl$home_score, na.rm = TRUE)

# Correlation  #############################################
cor(afl$home_score, afl$away_score) # Correlate home x away score

# Using the magrittr library, we can restructure to tidy this, as both
# variables are referenced from the same dataframe.
afl %$% cor(home_score, away_score) 

# The type of test (i.e. Spearman or Pearson) can also be 
# defined within the function
afl %$% cor(home_score, away_score, method = "spearman")
afl %$% cor(home_score, away_score, method = "pearson")

# Frequency tables #########################################
# For categorical variables, where we usually want a table of frequencies
# that tallies the number of times each value appears, use the table function 
afl %$% table(weekday) # Get frequency table of n games for each weekday

# This function is flexible and allows you to compute cross-tabulations 
# between two, three, or more variables simply by adding more variable names
afl %$% table(year, weekday) # Get frequency table of n game for year x weekday

# Summarise by group #######################################
# Back in the dark pre-tidyverse era it was surprisingly 
# difficult to compute descriptive statistics separately for each group. 
# The way I usually do this now is with the dplyr functions group_by() 
# and summarise(). Let’s suppose I want to compute the mean attendance 
# at AFL games broken down by who was playing. Conceptually, what I want 
# to do is “group by” two variables namely home_team and away_team, 
# and “then” for all unique combinations of those variables 
# “summarise” the data by computing the mean attendance. 

match_popularity <- afl %>%
  group_by(home_team, away_team) %>%
  summarise(attend = mean(attendance))

# Arranging data ###########################################
# The output from our previous command organised the output 
# alphabetically, which is less than ideal. It is usually more 
# helpful to sort the data set in a more meaningful way using dplyr::arrange. 
# To sort the match_popularity table in order of increasing attendance, 
# we do this:
  
match_popularity %>%
  arrange(attend)  # Sort by attendance (lower to high)

match_popularity %>%
  arrange(-attend) # Sort by attendance (high to low)


# Filtering case ############################################
# Lets focus on the Fitzroy team alone
match_popularity %>%
  filter(home_team == "Fitzroy") # Limit to records with Fitzroy as home team

match_popularity %>%
  filter(home_team=="Fitzroy" | away_team =="Fitzroy") # Limit to Fitzroy regardless of whether they are home or away.

filter_match_population <- 
  match_popularity %>%
  filter(home_team=="Fitzroy" | away_team =="Fitzroy") %>%
  arrange(attend) %>%
  print(n = 10) # We can combine this filter with the arrange function, and print the first 10 records to the console.

# Selecting variables  #######################################
# Many data analysis situations present you with a 
# lot of variables to work with, and you might 
# need to select a few variables to look at.
filter_selected_afl <- afl %>%
  filter(year == 1994 & round == 1) %>%  # Filter by year and round
  select(home_team, away_team, venue, weekday)  # and only show the listed variables

# Create new variable   #######################################
# Very often the raw data you are given doesn’t contain 
# the actual quantity of iteres, and you might need to compute 
# it from the other variables. The mutate function allows you to
# create new variables within a data frame:
  
mutate_afl <- afl %>%
  mutate(margin = abs(home_score - away_score)) %>%
  select(home_score, away_score, margin)
