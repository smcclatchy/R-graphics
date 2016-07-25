
################################################################
# An exploration of ggplot using boxplots.
# Sue McClatchy
# created 2016-07-20
################################################################

################################################################
# Load libraries and read in data.
################################################################# 
# Load the libraries. If you haven't installed the package yet, you'll need
# to do so by selecting ggplot2 from the Packages tab in RStudio, or by typing
# install.packages("ggplot2")

library(ggplot2)

cc_data <- read.csv(file="http://phenome.jax.org/grpdoc/MPD_projdatasets/CGDpheno3.csv")


################################################################
# Explore data.
#################################################################
# Explore the data variables. The first 4 columns contain strain, sex, and ID numbers.
# The remaining contain phenotype measurements with abbreviated names.
names(cc_data)

# How many mice?
dim(cc_data)

# How many mice of each sex?
table(cc_data$sex)

# How many mice of each strain?
table(cc_data$strain)

# How many mice of each strain by sex?
table(cc_data$sex, cc_data$strain)

# How do the first few rows of data look? Note the NAs in the data.
# These are missing values and can complicate analyses unless specifically addressed.
head(cc_data)

################################################################
# Plotting with ggplot
################################################################
# Use the ggplot() function, which is found in the ggplot2 library. 
# Quick reminder of ggplot syntax: ggplot(data, mapping) + layer(). 
# Plot red blood cells by strain.
ggplot(data = cc_data, mapping = aes(x = strain, y = RBC)) + 
  geom_boxplot()

# It’s difficult to distinguish the strain names on the x-axis, 
# so flip the coordinates to place strain on the y-axis and red blood cells on the x-axis.
ggplot(data = cc_data, mapping = aes(x = strain, y = RBC)) + 
  geom_boxplot() + 
  coord_flip()

# Sort the strains by mean red blood cells. Do this by re-ordering strains 
# within the mapping function aes(). Save the plot as a variable.
ggplot(data = cc_data, 
       mapping = aes(x = reorder(strain, RBC, FUN = "mean", na.rm = TRUE), y = RBC)) + 
  geom_boxplot() + 
  coord_flip()

# Add a point indicating the mean RBC value for each strain. 
# Add a statistical summary layer to do this. 
# Specify the color, shape and size of the point marking the mean.
ggplot(data = cc_data, 
       mapping = aes(x = reorder(strain, RBC, FUN = "mean", na.rm = TRUE), y = RBC)) + 
  geom_boxplot() + 
  coord_flip() + 
  stat_summary(fun.y = "mean", geom = "point", colour = "mediumpurple4", shape = 15, size = 2)

# Plot the data points over each boxplot. Since ggplot builds a plot layer by layer,
# the boxplot layer should come before the data points so as not to obscure them.
ggplot(data = cc_data,
       mapping = aes(x = reorder(strain, RBC, FUN = "mean", na.rm = TRUE), y = RBC)) + 
  geom_boxplot() + 
  geom_point() +
  coord_flip() + 
  stat_summary(fun.y = "mean", geom = "point", colour = "mediumpurple4", shape = 15, size = 2)

# Color the data points by sex by adding the aes() mapping function within the call to
# geom_point(). Save the plot as a variable. To view the plot, type the name of the variable.
rbc_boxplot <- ggplot(data = cc_data,
                      mapping = aes(x = reorder(strain, RBC, FUN = "mean", na.rm = TRUE),
                                                    y = RBC)) + 
  geom_boxplot() + 
  geom_point(aes(colour = sex)) +
  coord_flip() + 
  stat_summary(fun.y = "mean", geom = "point", colour = "mediumpurple4", shape = 15, size = 2)
rbc_boxplot

# Add axis labels. Redefine the plot variable.
rbc_boxplot <- rbc_boxplot +
  xlab("strain") + 
  ylab("red blood cell count (n/uL)")
rbc_boxplot

# Add a title. Redefine the plot variable.
rbc_boxplot <- rbc_boxplot + 
  ggtitle("Red Blood Cell Distribution by Strain")
rbc_boxplot

################################################################
# Subsetting data
################################################################
# Select a subset of the strains to create boxplots. Choose strains with the highest
# and lowest mean red blood cell counts. Include the parent strains of the F1s.
subset.cc_data <- subset(cc_data, strain %in% c("ACASTF1", "APWKF1", "CAST/EiJ", "PWK/PhJ",
                                      "A/J", "NODAF1", "NOD/ShiLtJ") == TRUE)

# Create boxplots from the subset
ggplot(data = subset.cc_data,
       mapping = aes(x = strain, y = RBC)) + 
  geom_boxplot()

# Re-order by mean RBC value as before. Save the plot as a variable.
subset_boxplot <- ggplot(data = subset.cc_data,
                         mapping = aes(x = reorder(strain, RBC, FUN = "mean", na.rm = TRUE),
                                       y = RBC)) + 
  geom_boxplot()
subset_boxplot

# Plot the data points by sex.The boxplots have already been drawn and saved 
# in the variable subset_boxplot. Layer the data points on top of the boxplots.
subset_boxplot <- subset_boxplot + 
  geom_point(aes(colour = sex))
subset_boxplot

# Add a purple square indicating the mean RBC value for each strain.
subset_boxplot <- subset_boxplot + 
  stat_summary(fun.y = "mean", geom = "point", colour = "mediumpurple4", shape = 15, size = 2)
subset_boxplot

# Add x and y axis labels.
subset_boxplot <- subset_boxplot + 
  xlab("strain") + 
  ylab("red blood cell count (n/uL)")
subset_boxplot

# Add a title.
subset_boxplot <- subset_boxplot + 
  ggtitle("Red Blood Cell Distribution by Strain")
subset_boxplot

# Output the plot to a PDF file. Set width and height. 
# Turn off the output to pdf with the dev.off() command.
pdf("subset-boxplot.pdf", width= 8, height = 9)
print(subset_boxplot)
dev.off()
