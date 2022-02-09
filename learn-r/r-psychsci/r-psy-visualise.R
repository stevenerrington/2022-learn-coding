# Learning R through the "R for Psychological Sciences" by Danielle Navarro tutorial

# Visualising data
# https://psyr.djnavarro.net/visualising-data.html

# Setup data   #################################################
# Load in "frames" dataset from the data directory
frames <- read_csv("./data/frames_ex2.csv")

# From this larger dataset, create a more focused dataframe with a mean response value.
frames_small <- frames %>%
  group_by(id, gender, age, condition) %>%
  summarise(response = mean(response))

# Histogram  ###################################################
# Plot distributions of ages
hist(frames_small$age) # In-built R histogram

frames_small %>%       # ggplot library figure
  ggplot(aes(x = age)) +
  geom_histogram()

# Plot distributions of ages, split by condition
# Using in-built R function:
layout(matrix(1:2, 1, 2)) # Subplot figure
hist(frames_small$age[frames$condition == "category"]) # Category condition
hist(frames_small$age[frames$condition == "property"]) # Property condition
# Using ggplot to split by condition:
frames_small %>%
  ggplot(aes(x = age)) + geom_histogram() + facet_wrap(~condition)

# Scatter #####################################################
frames_small %>% 
  ggplot(mapping = aes(x = age, y = response, color = condition)) + # Input x, y, and color split
  geom_point() # Generate the points on the plot

# In addition to the scatter, gpplot allows me to add new geoms that will 
# draw new layers to the plot. For example, geom_rug adds a visual 
# representation of the marginal distribution of the data on both axes:
frames_small %>% 
  ggplot(mapping = aes(x = age, y = response, colour = condition)) +
  geom_point() + # same as above, but...
  geom_rug() # ...add "rug" visualisation to plot

# Bar plot ####################################################
# To look at frequencies, we may want to plot a bar chart.
frames_small %>%
  ggplot(aes(x = gender)) +  # set up the mapping
  facet_wrap(~condition) +   # split it into plots
  geom_bar()                 # add the bars!

# Box plot  ####################################################
frames_small %>%
  ggplot(aes(x = condition, y = response, color = condition)) + 
  geom_boxplot() # This will plot the generic boxplot (but ofc, we can add more)

# Violin plot  ####################################################
frames_small %>%
  ggplot(aes(x = condition, y = response, color = condition)) + 
  geom_violin() + # This will plot the generic violin plot
  geom_jitter()   # and add jittered points

####################################################################
# Faceted plots (a.k.a. subplot) ###################################
####################################################################
# in a lot of cases, we want to plot multiple visualisations in one figure.
# We can do this by making a faceted plot. I think the equivalent is subplot

# In our example, suppose I want to draw separate boxplots for the response 
# variable for every possible test_item, broken down by condition and sample_size.

# Faceted boxplot
frames %>%                               # start with the full data set!
  ggplot(aes(
    x = factor(test_item),               # treat "test_item" as categorical
    y = response)) +                     # y variable is "response"
  facet_grid(sample_size ~ condition) +  # add faceting
  geom_boxplot()                         # add the boxplots :-)

# Facet bubble plot
# A bubble plot takes the form of a scatter plot, but instead of plotting 
# every data point as a unique dot, we plot dots at every location whose 
# size (area) is proportional to the number of cases at that location
frames %>%
  ggplot(aes(x = test_item, y = response)) + 
  facet_grid(condition ~ sample_size) +
  geom_count() # <- this is the geom for bubble

# This lets us see patterns obscured in a boxplot, but is a little unclear.
# To improve, we can color code the plot so the shade of the bubble reflects
# frequency of responses. Larger bubbles should stand out (dark colour), 
# but low frequency responses should fade into the light grey background

frames %>%
  ggplot(aes(x = test_item, y = response)) + 
  facet_grid(condition ~ sample_size) +
  geom_count(aes(colour = ..n..)) + 
  scale_colour_gradient(low = "grey80", high = "grey20") # Here we define our lower and upper bounds for the color scheme


# Error bars #############################################3
# It’s often the case that we want to summarise the data from a 
# single condition using a “mean plus error bar” style plot. 
# A common format is to plot the mean for every experimental
# condition and have error bars plotting the 95% confidence interval 
# for the mean.

# To do this, we will first create a summary data set in a new
# dataframe which includes the:
frames_mean <- frames %>%
  group_by(condition,sample_size,test_item) %>%
  summarise(
    mean_response = mean(response),    # mean
    lower = lsr::ciMean(response)[1],  # lower 95% CI
    upper = lsr::ciMean(response)[2]   # upper 95% CI
  )

# We can then generate the figure (saving it as a variable)
errorbar_fig <- frames_mean %>% 
  ggplot(aes(x = test_item, y = mean_response, colour = condition)) + # plot test item x mean response, color coded by condition)
  geom_point() + # add points 
  geom_errorbar(aes(ymin = lower, ymax = upper)) +  # add the error bars
  facet_wrap(~sample_size) # Subplot figure by the sample size

plot(errorbar_fig) # Output/print the figure

# As we saved the previous figure as a variable, we can actually add to it
# in future. For example, we can add a line to the above figure
errorbar_fig_line = errorbar_fig + geom_line()

# Saving output ##########################################
# We can save the figures we create, using the code below.
ggsave(
  filename = "./figures/r-psy-visualise.pdf",
  plot = errorbar_fig_line,
  width = 16,
  height = 8,
  units = "cm"
)

# I think it does, but I need to check if this saves as a vector image.

