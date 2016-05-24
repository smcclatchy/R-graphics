# This script creates scatterplots and boxplots from the Collaborative Cross founder
# and F1 survey data in Mouse Phenome Database at
# http://phenome.jax.org/db/q?rtn=projects/details&id=439
# Sue McClatchy 
# created 2015-06-14
# modified 2015-10-24 simplified by saving plots to a variable

library(ggplot2)

cc <- read.csv(file = "http://phenome.jax.org/grpdoc/MPD_projdatasets/CGDpheno3.csv")

######################################################################################
# Histogram and density plots
######################################################################################

# Create a histogram of red blood cell counts.
ggplot(data = cc, aes(x = RBC)) + 
  geom_histogram()

# Set the binwidth to 0.1.
ggplot(data = cc, aes(x = RBC)) + 
  geom_histogram(binwidth = 0.1)

# Draw a vertical line through the mean value. Outline each bar in black and 
# fill them with white.
ggplot(cc, aes(x=RBC)) +
  geom_histogram(binwidth = 0.1, colour="black", fill = "white") +
  geom_vline(aes(xintercept=mean(RBC, na.rm=T)), color="red", linetype="dashed", size=1)
   
# Draw separate vertical lines for the mean by sex. Red is the mean value for females, 
# blue for males.
ggplot(cc, aes(x=RBC)) +
  geom_histogram(binwidth = 0.1, colour="black", fill = "white") +
  geom_vline(aes(xintercept=mean(RBC[sex == "f"], na.rm=T)), color="red", linetype="dashed", size=1) +
  geom_vline(aes(xintercept=mean(RBC[sex == "m"], na.rm=T)), color="blue", linetype="dashed", size=1)

# Produce separate histograms by sex and lighten the fill colors.
ggplot(data = cc, aes(x = RBC, fill = sex)) + 
  geom_histogram(binwidth = 0.1, alpha = .5, position = "identity")

# Produce density plots by sex with lightened fill colors.
ggplot(data = cc, aes(x = RBC, fill = sex)) + 
  geom_density(alpha = 0.5)

######################################################################################
# Scatterplots
######################################################################################

# Scatterplot red blood cells by strain.
ggplot(data = cc, aes(x = strain, y = RBC)) + 
  geom_point()

# Scatterplot red blood cells by strain and sex.
ggplot(data = cc, aes(x = strain, y = RBC)) +
  geom_point(aes(colour = sex))

# The strain names on the x-axis are illegible. We could switch x and y axes and place
# strain names on the y-axis for legibility, however, we would like to apply a 
# statistical summary to values on the y-axis, so we'll leave RBC counts on the y 
# and flip the coordinates. 

# Reorder strains by mean RBC count. Save plot as a variable.
rbc_plot <- ggplot(data = cc, aes(x = reorder(strain, RBC, FUN = "mean", na.rm = TRUE), y = RBC)) + 
  geom_point(aes(colour = sex)) + 
  coord_flip()
rbc_plot

# Shrink the strain labels using a theme.
rbc_plot <- rbc_plot + theme(axis.text.y = element_text(size = rel(0.5)))
rbc_plot

# Label the axes. Remember that y and x axes are flipped, so flip the labels.
rbc_plot <- rbc_plot + xlab("strain") + ylab("red blood cell count (n/uL) ")
rbc_plot

# Apply a statistical summary function (mean) to red blood cell count. We wouldn't be able to 
# do this if we hadn't flipped the axes earlier with coord_flip().
rbc_plot <- rbc_plot + stat_summary(fun.y = "mean", geom = "point", colour = "mediumpurple4")
rbc_plot

# Add a title.
rbc_plot <- rbc_plot + ggtitle("Mean Red Blood Cells by Strain")
rbc_plot

# Output the plot to a scalable vector graphics (svg) file. Set width and height.
svg("rbc-strain-means.svg", width= 8, height = 9)
print(rbc_plot)
dev.off()

######################################################################################
# Boxplots
######################################################################################

# Select a subset of the strains to create boxplots. Choose strains with the 4 highest
# and 4 lowest mean red blood cell counts.
subset.cc <- subset(cc, strain %in% c("ACASTF1", "APWKF1", "B6CASTF1", "CASTNZOF1",
                                      "A129SF1", "A/J", "NODAF1", "NOD/ShiLtJ") == TRUE)

# Create boxplots from the subset. Re-order by mean RBC value as before.
ggplot(data = subset.cc, 
                      aes(x = reorder(strain, RBC, FUN = "mean", na.rm = TRUE),
                          y = RBC)) + geom_boxplot()

# This time there's no need to flip the axes since the strain names are legible on the 
# x-axis. We also won't apply a statistical summary (the mean in prior example)
# to y-axis values this time. We have already re-ordered strains by mean RBC values
# but won't plot a point indicating the mean for each strain.

# Color boxplots by sex. Indicate outliers as purple triangles. Save plot as a variable.
rbc_boxplot <- ggplot(data = subset.cc,
                      aes(x = reorder(strain, RBC, FUN = "mean", na.rm = TRUE),
                          y = RBC)) +
  geom_boxplot(aes(colour = sex),
               outlier.colour = "mediumpurple", outlier.shape = 17)
rbc_boxplot

# The upper whisker extends to the highest value within 1.5 * inter-quartile range, 
# (distance between first and third quartiles). The lower whisker extends 
# to the lowest value within 1.5 * IQR of the hinge. Data beyond the end of the whiskers
# (outliers) are plotted as triangles.

# Rotate the strain labels by 45 degrees and lower them vertically so that they don't
# run into the plot area.
rbc_boxplot <- rbc_boxplot + theme(axis.text.x = element_text(angle = 45, vjust = 0.7))
rbc_boxplot

# Add x and y axis labels.
rbc_boxplot <- rbc_boxplot + xlab("strain") + 
  ylab("red blood cell count (n/uL)")
rbc_boxplot

rbc_boxplot <- rbc_boxplot + ggtitle("Red Blood Cell Distribution by Strain and Sex")
rbc_boxplot

# Output the plot to a PDF file. Set width and height.
pdf("rbc-boxplot.pdf", width= 8, height = 9)
print(rbc_boxplot)
dev.off()

