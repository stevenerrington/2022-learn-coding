# Learning R through the "R for Psychological Sciences" by Danielle Navarro tutorial

# Prelude
# https://psyr.djnavarro.net/prelude-to-data.html

setwd("./r-psychsci/") # Project references ./learn-r/, so let's move it to our /r-psychsci dir for this script

# Load the installed tidyverse package (installed via install.packages)
library(tidyverse) 
# The tidyverse is an opinionated collection of R packages designed for data science. 
# All packages share an underlying design philosophy, grammar, and data structures.

# Load in AFL data from CSV file
afl <- read_csv("./data/afl.csv")
afl # ... and view the output to check

# Get average (mean) attendence split by year and game type
# In the syntax below, %>% works as a "pipe" operation, feeding
# data from one function to another. 
attendance <- afl %>% 
  group_by(year, game_type) %>% 
  summarise(attendance = mean(attendance)) 

attendance # ,,, and again, look at the output

# Now we can look at plotting this data to examine trends over time
attendanceFig <- attendance %>%
  ggplot(aes(x = year, y = attendance)) +  # year on x-axis, attendance on y-axis
  facet_wrap(~game_type) +                 # separate "facets" (subplots) for each game_type
  geom_point() +                           # add the data as "points"
  geom_smooth()                            # overlay a smooth regression line

plot(attendanceFig)                        # Generate the plot



