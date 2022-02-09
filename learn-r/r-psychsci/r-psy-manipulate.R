# Learning R through the "R for Psychological Sciences" by Danielle Navarro tutorial

# Manipulate data
# https://psyr.djnavarro.net/manipulating-data.html

setwd("./r-psychsci/"); library(tidyverse) 

#############################################################
# Setup data   #################################################
# We previously looked at the "frames" data set in the visualisation script
# Here, each row is a trial for each participant in each condition
# This is known as a long format
frames <- read_csv("./data/frames_ex2.csv")

# However, this data was not formatted like this when extracted from OSF.
# From OSF, the data was in a wide format: 
#       the data frame contains only one row per person, 
#       and each judgment they make is stored as a separate variable. 
wide_frames <- read_csv("./data/frames_ex2_wide.csv")

# Converting from long to wide frame  ###########################
# We can convert from wide-to-long using the function below
long_frames <- wide_frames %>% 
  gather(key = "query", value="response",
         "SS2-R1", "SS2-R2","SS2-R3","SS2-R4","SS2-R5","SS2-R6","SS2-R7",
         "SS6-R1","SS6-R2","SS6-R3","SS6-R4","SS6-R5","SS6-R6","SS6-R7", 
         "SS12-R1","SS12-R2","SS12-R3","SS12-R4","SS12-R5","SS12-R6","SS12-R7")

# We can convert from long-to-wide using the function below:
wide_frames_conv <- long_frames %>% spread(key = "query", value = "response")

#############################################################
# Splitting a variable   #########################################
# The long_frames data frame we created is close to what we need, 
# but the query variable isn’t quite right. A value of "SS2-R1" 
# corresponds to a trial on which the sample size was 2 and the test item was 1.
# This should properly be two variables, one specifying the sample_size 
# and the other specifying the value of the test_item.

# We can do this using the following function (& reversed using unite())
long_frames_sep = 
  long_frames %>% 
  separate(
    col = query, 
    into = c("sample_size","test_item"), 
    sep = "-R"
  )

long_frames_uni = 
  long_frames_sep %>% 
  unite(
    col = "united", 
    "sample_size","test_item", 
    sep = "-R"
  )

# However, some issues are still outstanding. For example, test_item is 
# stored as a chr data type, when it should be numeric. We can change this by
# using the "mutate" function. 
long_frames <- long_frames %>% 
  separate(      # Split 
    col = query, # Query variable
    into = c("sample_size","test_item"), #Into two variables
    sep = "-R" # Where this string is observed
  ) %>%
  mutate(test_item = as.numeric(test_item)) # Change item to numeric.

long_frames

#############################################################
# Recoding variables ####################################
# Now we have sample size as it's own variable, we can recode it 
# into a structure that is a little more intuitive. Below,
# we can relabel the string as small, medium, or large, based on the string
# observed in the sample_size column.
long_frames <- long_frames %>%
  mutate(sample_size = dplyr::recode(
    sample_size, 
    "SS2" = "small", 
    "SS6" = "medium", 
    "SS12" = "large")
  )

long_frames

# An alternative approach is to use the "case_when" function
# (... I'm actually not sure about this and need to come back to it...)
long_frames <- long_frames %>%
  mutate(n_obs = case_when(
    sample_size == "small" ~ 2,
    sample_size == "medium" ~ 6,
    sample_size == "large" ~ 12
  ))
long_frames


#############################################################
# Processing dates ##########################################
# In order to process dates more easily (given the variability in how they are coded)
# we can use the "lubridate" library from tidyverse
library(lubridate)

# This helps provide a common format for dates across all styles
ymd(20101215)
ymd("2010/12/15")
ymd("2010 December 15")

# Let's use an example of poorly-formatted date data to learn on
oddball <- readLines("./data/oddballdate2.csv")

# Here we see there is a mix of date types
# We can use different functions to parse them out
dmy(oddball)
dmy_hm(oddball)

# Each function converts the dates it can,inserts NA for the dates it can’t, 
# and loudly complain that something is amiss.

# We can then combine these outcomes to get a clean date data set.
d1 <- oddball %>% dmy_hm() %>% date()
d2 <- oddball %>% dmy() 
clean_dates <- case_when(
  is.na(d1) ~ d2, 
  TRUE ~ d1
)
clean_dates

# However, one NaN remains!...
oddball[is.na(clean_dates)]

# Here we see, that it is encoded as mm/dd/yy
# This can be addressed by changing the function from dmy to mdy
oddball_fix = mdy(oddball[is.na(clean_dates)])

#############################################################
# Combining data frames #####################################

# Binding data together #
# Here we are looking to combine a dataset that is split across entries, but 
# has the same content (i.e. same columns)
# . import data examples, each with subsets of rows that we need to concatenate
nightgarden_top <- read_csv("./data/nightgarden_top.csv")
nightgarden_middle <- read_csv("./data/nightgarden_middle.csv")
nightgarden_bottom <- read_csv("./data/nightgarden_bottom.csv")

# As they have the same variable/column names, we can use dplyr::bind_rows() 
# to concatenate these data frames vertically:
nightgarden_all <- bind_rows(nightgarden_top, nightgarden_middle, nightgarden_bottom)

# (there is also an analogous function dplyr::bind_columns() that concatenates horizontally.)

# Joining data together #
# More complicated situations arise when each data frame potentially contains information about 
# the same cases and variables, but not necessarily all the same ones.

# We will start by importing a dataset
demographics <- read_csv("./data/discworld_demographics.csv")
responses <- read_csv("./data/discworld_responses.csv")

# Here we are looking to join these datasets, which differ in the content
# they hold, but share other common features (i.e. ID). There are several
# approaches to joining

# 1: inner_join | this will keep records that are present in both sets
inner_join(demographics, responses)
# 2: full_join | this will keep every record, but note NaN where entries are missing
full_join(demographics, responses)
# 3: left_join | this will only keep records that have entries in the left most (first) dataset
left_join(demographics, responses)

# other options are also available, but not discussed here 
# (i.e. right_join, semi_join, anti_join).




