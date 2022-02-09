# Clear environment
rm(list = ls())

# Using pipes: #########################################################
# EXAMPLE: I have collected data from 10 participants in an experiment, 
# and have recorded their response times to some stimulus, expressed in milliseconds:

response_time <- c(420, 619, 550, 521, 1003, 486, 512, 560, 495, 610)

hist(response_time) # Histogram of response times

# As is typical with RT data, there is a positive skew. To address this, I may
# want to work with a log transformed value. This can be done going step by step through
# the following function

a <- log(response_time) # Take the log
b <- mean(a) # Calculate the mean
c <- exp(b) # Then translate back from log, by using exponential
d <- round(c, digits = 2) # Round the output value
print(d) # Print what we get

# However, this produces a lot of extraenous variables and is untidy. Instead,
# we can look at nesting these functions, using a pipe (%>%)
# Unlike other operators, it isn’t part of base R. 
# It was introduced as part of the magrittr package, and has become widely adopted.

response_time %>% log(.) %>% 
  mean(.) %>% 
  exp(.) %>% 
  round(., digits = 2) %>%
  print(.)

# Here we see that the outcome (.) of the statement prior to the pipe, gets 
# passed to the next function