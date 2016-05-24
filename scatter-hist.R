# This script produces scatterplots and histograms
# from CC founder strain data. 
# Sue McClatchy
# 2015-10-22 created

# Load the library and read in the data.
library(ggplot2)
cc <- read.csv(file = "http://phenome.jax.org/grpdoc/MPD_projdatasets/CGDpheno3.csv")

# Look at the data structure. Look at the number of animals
# by strain, and the number by strain and sex.
str(cc)
sort(table(cc$strain))
table(cc$strain, cc$sex)

# Scatterplot percent reticulocytes by red blood cell count.
qplot(x = RBC, y = pctRetic, data = cc)

# Create a histogram of red blood cell counts.
qplot(x = RBC, data = cc)

# Add a smoother to the scatterplot.
qplot(x = RBC, y = pctRetic, data = cc, 
      geom = c("point", "smooth"))

# Remove the confidence intervals from the smoother.
qplot(x = RBC, y = pctRetic, data = cc, 
      geom = c("point", "smooth"), se = FALSE)

# Color points by sex.
qplot(x = RBC, y = pctRetic, data = cc, 
      colour = sex)

# Color points by sex, add a smoother, and add axis labels and a title.
qplot(x = RBC, y = pctRetic, data = cc, 
      geom = c("point", "smooth"),
      colour = sex,
      se = FALSE,
      xlab = "red blood cell count (n/uL)",
      ylab = "percent reticulocytes",
      main = "Percent Reticulocytes by Red Blood Cell Count")

# Facet by sex.
qplot(x = RBC, y = pctRetic, data = cc, 
      geom = c("point", "smooth"),
      facets = . ~ sex,
      colour = sex)